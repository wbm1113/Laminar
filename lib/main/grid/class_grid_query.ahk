class grid_query extends grid_lines
{
    extractAlias(criteria) {
        if isObject(criteria) {
            if isObject(criteria.alias)
                return criteria.alias.string
            return criteria.alias
        }
        return criteria
    }

    updateReference(criteria) {
        alias := this.extractAlias(criteria)

        if alias.length < 12
            return grid.shapes[alias]
        
        for i, s in this.shapes
            for j, l in s.linesOriginatingFrom
                if (j = alias)
                    return l
        
        return 0
    } 

    extractType(criteria) {
        return this.updateReference(criteria).type
    }

    isLine(criteria) {
        criteria := this.updateReference(criteria)
        return (criteria.type = "line") ? criteria : 0
    }

    isShape(criteria) {
        criteria := this.updateReference(criteria)
        return (criteria.type = "shape") ? criteria : 0
    }

    isLineAnchor(criteria) {
        criteria := this.isShape(criteria)
        return (criteria && criteria.isLineAnchor) ? criteria : 0
    }
}