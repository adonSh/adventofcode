from sys import stdin

def find_marker(buf: str, marker_len: int) -> int:
    for i in range(len(buf)):
        marker = buf[i:i+marker_len]
        if len(marker) == len(set(marker)):
            return i + marker_len

    return -1

def main() -> None:
    buf = stdin.read().strip()

    print(find_marker(buf, 4))
    print(find_marker(buf, 14))

if __name__ == '__main__':
    main()
