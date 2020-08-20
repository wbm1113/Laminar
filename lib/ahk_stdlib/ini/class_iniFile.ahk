class iniFile
{
    sections := object()
    sectionNames := []

    __new(alias, path) {
        this.alias := alias
        this.path := path
    }

    addSection(sectionName) {
        s := new iniSection(this, sectionName)
        this.sections[sectionName] := s
        return s
    }

    getSections() {
        iniRead, lineDelimitedSectionList, % this.path
        loop, parse, % lineDelimitedSectionList, `n
        {
            this.sections[a_loopField] := new iniSection(this, a_loopField)
            this.sectionNames.push(a_loopField)
        }
    }

    getSectionsContaining(criteria) {
        sectionsContaining := []
        for a, s in this.sections {
            if inStr(a, criteria)
                sectionsContaining.push(a)
        }
        return sectionsContaining
    }
    
    printSections() {
        printArray.call(this.sectionNames)
    }
}

class iniSection
{
    __new(parent, alias) {
        this.parent := parent
        this.alias := alias
    }

    read(key) {
        iniRead, retVal, % this.parent.path, % this.alias, % key
        retVal := strReplace(retVal, "€", "`r`n")
        retVal := strReplace(retVal, "¢", "=")
        return retVal
    }

    write(key, value) {
        value := strReplace(value, "`r`n", "€")
        value := strReplace(value, "`r", "€")
        value := strReplace(value, "`n", "€")
        value := strReplace(value, "=", "¢")
        iniWrite, % value, % this.parent.path, % this.alias, % key
    }

    writePseudoArray(key, largeString) {
        components := ceil(strLen(largeString) / 5000)
        stringPos := 1

        loop % components
            setFormat.decimal()
            , this.write(key a_index, subStr(largeString, stringPos, 5000))
            , stringPos += 5000      
    }

    readPseudoArray(key) {
        fullText := ""
        loop 1000 {
            element := this.read(key a_index)
            if (element = "ERROR")
                break
            fullText .= element
        }
        return fullText
    }

    allSectionLinesToArray() {
        retVal := []
        iniRead, sectionLines, % this.parent.path, % this.alias
        loop, parse, % sectionLines, `n
        {
            retVal.push(a_loopField)
        }
        return retVal
    }
}