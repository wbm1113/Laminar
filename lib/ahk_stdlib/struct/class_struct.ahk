class mem extends protoClass
{
    static struct := object()

    add(alias) {
        this.struct[alias] := new struct(alias)
    }
}

class struct extends protoClass
{
    __new(alias) {
        this.alias := alias
        , this.members := object()
        , this.size := 0
    }

    define(members*) {
        for i, m in members
            this.members[m] := this.size + 0
            , this.size += 4
        return this
    }

    declare() {
        this.setCapacity("p", this.size + 0)
        this.ptr := this.getAddress("p")
        dllCall("RtlFillMemory", "int", this.ptr + 0, "int", this.size + 0, "char", 0)
        return this
    }

    reset() {
        dllCall("RtlFillMemory", "int", this.ptr + 0, "int", this.size + 0, "char", 0)
    }

    get(member) {
        return numGet(this.ptr + 0, this.members[member] + 0, "int")
    }

    put(member, n) {
        numPut(n, this.ptr + 0, this.members[member] + 0)
    }
}