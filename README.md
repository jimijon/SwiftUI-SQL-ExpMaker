# SwiftUI-SQL-ExpMaker
This is a self contained view to manage the creation and state of a SQL Where clause. 

It is also a good example on using a Slider, a Segment Picker, and various bindings for flexibility and reuse.
Slider, Picker, and Bindings 

# Installation
There is one dependency. We use the great slider here:

https://github.com/spacenation/sliders

You will need to use the XCode Swift Packages to add it to your project

# Usuage
This assumes you have some datamodel that will hold the various bindings for each query. This shows how to use a Picker and a Slider to output different SQL where clauses.

SwiftUI XCode Beta 7 compatible

```
TrendSlider(
                        col: .constant(dataModel.column),
                        op: $dataModel.operand,
                        val: $dataModel.value,
                        lBound: .constant(1940.0),
                        uBound: .constant(2019.0),
                        lRange: $dataModel.lowerValue,
                        uRange: $dataModel.upperValue,
                        step: .constant(1.0)
            )
```

The op binding determines whether this is a single value query or a BETWEEN Sql Query.
