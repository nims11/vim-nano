import os
import time
import sys
row1 = [
    ("^G", "Get Help"),
    ("^O", "Write Out"),
    ("^F", "Where Is"),
    ("^K", "Cut Text"),
    ("^J", "Justify"),
    ("^C", "Cur Pos"),
    ("^Y", "Prev Page"),
    ("M-\\", "First Line"),
    ("M-W", "WhereIs Next"),
    ('^^', "Mark Text"),
    ("M-}", "Indent Text"),
]
row2 = [
    ("^X", "Exit"),
    ("^R", "Read File"),
    ("^\\", "Replace"),
    ("^U", "Uncut Text"),
    ("^T", "To Spell"),
    ("^_", "Go To Line"),
    ("^V", "Next Page"),
    ("M-/", "Last Line"),
    ("M-]", "To Bracket"),
    ("M-C", "Copy Text"),
    ("M-{", "Unindent Text"),
]
def generate(cols):
    str1, str2 = '', ''
    elt_width = max(15, cols//len(row1))
    cnt = 0
    for (k1, v1), (k2, v2) in zip(row1, row2):
        cur_str1 = '\033[7m%s\033[0m %s ' % (k1, v1)
        cur_str2 = '\033[7m%s\033[0m %s ' % (k2, v2)
        cnt += 8
        while len(cur_str1) - 8 < elt_width:
            cur_str1 += ' '
        while len(cur_str2) - 8 < elt_width:
            cur_str2 += ' '
        if len(cur_str1) - 8 > elt_width:
            cur_str1 = cur_str1[:elt_width+8]
        if len(cur_str2) - 8 > elt_width and k2 != row2[-1][0]:
            cur_str2 = cur_str2[:elt_width+8]
        str1 += cur_str1
        str2 += cur_str2
        if len(str1) - cnt >= cols or len(str2) - cnt >= cols:
            str1 = str1[:cols+cnt]
            str2 = str2[:cols+cnt]
            return str1 +'\n'+ str2 + '\n'

    return '\n' + str1 +'\n'+ str2

prev_cols = -1
while True:
    # os.system('reset')
    _, cols = os.popen('stty size', 'r').read().split()
    cols = int(cols) - 4
    if cols != prev_cols:
        sys.stdout.write(generate(cols))
        sys.stdout.flush()
        prev_cols = cols
    time.sleep(0.3)
