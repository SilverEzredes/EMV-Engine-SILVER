local function u32(x)
    return x & 0xffffffff
end

local function rotl32(x, r)
    return u32((x << r) | (x >> (32 - r)))
end

local function fmix32(h)
    h = h ~ (h >> 16)
    h = u32(h * 0x85ebca6b)
    h = h ~ (h >> 13)
    h = u32(h * 0xc2b2ae35)
    h = h ~ (h >> 16)
    return h
end

local function calc32(str)
    local len = #str
    local h1 = 0

    local c1 = 0xcc9e2d51
    local c2 = 0x1b873593

    local i = 1
    while i + 3 <= len do
        local k1 =  string.byte(str, i) | (string.byte(str, i + 1) << 8) | (string.byte(str, i + 2) << 16) | (string.byte(str, i + 3) << 24)
        k1 = u32(k1 * c1)
        k1 = rotl32(k1, 15)
        k1 = u32(k1 * c2)

        h1 = h1 ~ k1
        h1 = rotl32(h1, 13)
        h1 = u32(h1 * 5 + 0xe6546b64)

        i = i + 4
    end

    local k1 = 0
    local rem = len - i + 1

    if rem >= 3 then k1 = k1 | (string.byte(str, i + 2) << 16) end
    if rem >= 2 then k1 = k1 | (string.byte(str, i + 1) << 8) end
    if rem >= 1 then
        k1 = k1 | string.byte(str, i)
        k1 = u32(k1 * c1)
        k1 = rotl32(k1, 15)
        k1 = u32(k1 * c2)
        h1 = h1 ~ k1
    end

    h1 = h1 ~ len
    return fmix32(h1)
end

murmur3 = {
    calc32 = calc32
}
return murmur3