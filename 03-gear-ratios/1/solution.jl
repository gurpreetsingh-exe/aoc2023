f = open("input", "r")
lines = readlines(f)
close(f)

digits = Set()

for (i, line) in enumerate(lines)
    for (j, ch) in enumerate(line)
        if isdigit(ch) || ch == '.'
            continue
        end
        for row in range(i - 1, i + 1)
            for col in range(j - 1, j + 1)
                if row < 1 || row >= length(lines) + 1 || col < 1 || col >= length(lines[row]) + 1
                    continue
                end
                if !isdigit(lines[row][col])
                    continue
                end
                while col > 1 && isdigit(lines[row][col - 1])
                    col -= 1
                end
                push!(digits, (row, col))
            end
        end
    end
end

xs = []

for (i, j) in digits
    s = j
    while j < length(lines[i]) + 1 && isdigit(lines[i][j])
        j += 1
    end
    push!(xs, parse(Int64, lines[i][s:j-1]))
end

display(sum(xs))
