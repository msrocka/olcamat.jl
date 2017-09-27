# olcamat
A Julia package for reading and writing files in the [olcamat]() format. As the
`olcamat` format is still in development this package is still very experimental.
This package currently only supports the dense array storage format in column
major-order.

## Usage

```julia
using olcamat

A = olcamat.read_matrix("A.bin")
B = olcamat.read_matrix("B.bin")

tech_index = olcamat.read_tech_index("index_A.csv")
envi_index = olcamat.read_envi_index("index_B.csv")

# calculate the inventory result for 1 unit of the first process
f = zeros(size(A)[1])
f[1] = 1.0
s = A \ f
g = B * s

process = tech_index[1]
println("Inventory result for process " * process.process_name)
rows = size(B)[1]
for row = 1:rows
    flow = envi_index[row]
    println(flow.flow_name * "\t" * string(g[row]) * "\t" * flow.unit_name)
end
```