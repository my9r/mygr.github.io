# sudo chmod +x test.sh
# ./test.sh -s box.cpp -t 1 -m 512

#!/bin/bash

# ======= 彩色输出定义 =======
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # 无色

# ======= 默认参数 =======
SOURCE=""
DATADIR="."
TIMELIMIT=1.0     # 秒，软性 TLE 判定时间
MEMLIMIT_MB=512   # MB，MLE 限制

# ======= 解析参数 =======
while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--source)
            SOURCE="$2"
            shift 2
            ;;
        -d|--datadir)
            DATADIR="$2"
            shift 2
            ;;
        -t|--time)
            TIMELIMIT="$2"
            shift 2
            ;;
        -m|--memory)
            MEMLIMIT_MB="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 -s SOURCE [-d DATADIR] [-t TIME_LIMIT] [-m MEMORY_LIMIT_MB]"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# ======= 检查源代码是否提供 =======
if [ -z "$SOURCE" ]; then
    echo -e "${RED}Error: Source file not specified. Use -s FILE${NC}"
    exit 1
fi

# ======= 设置常量 =======
EXEC="./program_exec"
MEMLIMIT_KB=$((MEMLIMIT_MB * 1024))
FORCE_TIME=$(printf "%.1f" "$(echo "$TIMELIMIT * 2" | bc)")

# ======= 编译 =======
g++ "$SOURCE" -o "$EXEC" -O2 -std=c++17 2> compile.log
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}CE${NC}"
    cat compile.log
    exit 1
fi

# ======= 设置内存限制 =======
ulimit -v $MEMLIMIT_KB

# ======= 测试开始 =======
total=0
passed=0

for INFILE in "$DATADIR"/*.in; do
    BASENAME=$(basename "$INFILE" .in)
    OUTFILE="$DATADIR/$BASENAME.out"
    ANSFILE="$DATADIR/$BASENAME.ans"

    # ======= 运行程序 =======
    /usr/bin/time -v timeout "${FORCE_TIME}s" "$EXEC" < "$INFILE" > "$OUTFILE" 2> time.log
    EXIT_CODE=$?

    # ======= 提取资源信息 =======
    MEM=$(grep "Maximum resident set size" time.log | awk '{print $6}')
    UTIME=$(grep "User time (seconds)" time.log | awk '{print $4}')
    MEM=${MEM:-0}
    UTIME=${UTIME:-0}
    TIME=$UTIME
    MEM_MB=$((MEM / 1024))

    RESULT=""
    is_tle=0

    # ======= 优先判断 MLE（基于信号） =======
	if [ $EXIT_CODE -eq 137 ] || [ $EXIT_CODE -eq 139 ]; then
		RESULT="MLE"
	elif [ $EXIT_CODE -eq 124 ]; then
        RESULT="TLE"
        TIME=">${FORCE_TIME}"
    elif [ $EXIT_CODE -ne 0 ]; then
        RESULT="RE(?)"
    else
        # 非强制 TLE（软性 TLE）
        cmp=$(awk -v t="$TIME" -v limit="$TIMELIMIT" 'BEGIN{print (t > limit) ? 1 : 0}')
        if [ "$cmp" -eq 1 ]; then
            RESULT="TLE"
            is_tle=1
        fi
    fi

    # ======= 比较输出结果 =======
    if [ -z "$RESULT" ]; then
        diff -Z -q <(sed 's/[ \t]*$//' "$OUTFILE" | sed '/^$/d') <(sed 's/[ \t]*$//' "$ANSFILE" | sed '/^$/d') > /dev/null
        if [ $? -eq 0 ]; then
            if [ $is_tle -eq 0 ]; then
                RESULT="AC"
                ((passed++))
            fi
        else
            RESULT="WA"
        fi
    fi

    # ======= 彩色输出一行 =======
    case $RESULT in
        AC)
            COLOR=$GREEN
            ;;
        CE)
            COLOR=$YELLOW
            ;;
        *)
            COLOR=$RED
            ;;
    esac

    printf "Test #%-10s\t${COLOR}%-4s${NC}\tTime: %ss\tMemory: %sMB\n" "$BASENAME" "$RESULT" "$TIME" "$MEM_MB"
    ((total++))
done

# ======= 汇总结果 =======
echo "============================"

# 计算通过率并决定颜色
if [ $total -eq 0 ]; then
    rate=0
else
    rate=$(awk "BEGIN { printf \"%.2f\", $passed / $total }")
fi

if (( $(echo "$rate < 0.3" | bc -l) )); then
    SCORE_COLOR=$RED
elif (( $(echo "$rate < 1" | bc -l) )); then
    SCORE_COLOR=$YELLOW
else
    SCORE_COLOR=$GREEN
fi

# 输出彩色 Score 行
echo -e "${NC}Score:${NC} ${SCORE_COLOR}${passed}${NC} / ${GREEN}${total}${NC}"