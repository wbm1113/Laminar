"".base.__get               := func("getProp") 
getProp(this, prop) {
    if (prop = "length")
        return strLen(this)
    if (prop = "memAddress")
        return &this
}

"".base.isEven              := func("isEven")
isEven(this) {
    if mod(this, 2)
        return 0
    return 1
}

"".base.removeLetters       := func("removeLetters")
removeLetters(this) {
    return regExReplace(this, "[^0-9]")
}

"".base.isInteger           := func("isInteger")
isInteger(this) {
    if (this ~= "[^\d]")
        return 0
    return 1
}

"".base.modDown             := func("modDown")
modDown(this, n) {
    return this - mod(this, n)
}

"".base.modUp               := func("modUp")
modUp(this, n) {
    return this + mod(this, n)
}

"".base.toHex               := func("toHex")
toHex(this) {
    retVal := Format("{1:#x}", this)
    return retVal
}

"".base.getEndCharacter     := func("getEndCharacter")
getEndCharacter(this) {
    return subStr(this, 0)
}