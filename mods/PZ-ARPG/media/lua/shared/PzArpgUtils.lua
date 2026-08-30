function printTable(table, indent)
    if not table then return end

    indent = indent or ""

    for key, value in pairs(table) do
        if type(value) == "table" then
            print(indent .. key .. " (table):")
			printTable(value, indent .. "  ")
        else
            print(indent .. key .. ":", value)
        end
    end
end