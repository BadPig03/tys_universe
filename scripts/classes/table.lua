local Table = TYU:RegisterNewClass()

function Table.First(list, predicate)
    predicate = predicate or function() return true end
    for k, v in pairs(list) do
        if predicate(v, k) then
            return v
        end
    end
    return nil
end

function Table.GetField(tbl, ...)
    local resultData = tbl
    for _, n in ipairs({...}) do
        resultData = resultData[n]
        if not resultData then
            return nil
        end
    end
    return resultData
end

function Table.SetField(tbl, value, startName, ...)
    local parentData = tbl
    local dataPath = {startName, ...}
    for i, fieldName in ipairs(dataPath) do
        if i == #dataPath then
            parentData[fieldName] = value
        else
            if type(parentData[fieldName]) ~= "table" then
                parentData[fieldName] = {}
            end
            parentData = parentData[fieldName]
        end
    end
end

function Table.Clear(tbl)
    for k, v in pairs(tbl) do
        tbl[k] = nil
    end
end

function Table.Contain(tbl, value)
    for _, v in pairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

function Table.Clone(tbl)
    if type(tbl) ~= "table" then
        return tbl
    end
    local clone = {}
    for originKey, originValue in pairs(tbl) do
        clone[Table.Clone(originKey)] = Table.Clone(originValue)
    end
    return setmetatable(clone, getmetatable(tbl))
end

function Table.Compare(t1, t2)
    if t1 == t2 then
        return true
    end
    if type(t1) ~= "table" or type(t2) ~= "table" then
        return false
    end
    for key, value in pairs(t1) do
        if t2[key] == nil or not Table.Compare(value, t2[key]) then
            return false
        end
    end
    for key in pairs(t2) do
        if t1[key] == nil then
            return false
        end
    end
    return true
end


function Table.ReplaceContent(tbl, data)
    if data == nil then
        return
    end
    for k in pairs(tbl) do
        tbl[k] = nil
    end
    for k, v in pairs(data) do
        tbl[k] = v
    end
end

function Table.RemoveValueInTable(tbl, value)
    if tbl == nil or value == nil then
        return
    end
    for index = #tbl, 1, -1 do
        if tbl[index] == value then
            table.remove(tbl, index)
        end
    end
end


return Table