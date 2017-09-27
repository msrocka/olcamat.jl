module olcamat

struct MatrixHeader
    version::Int32
    format::Int32
    dataType::Int32
    typeLength::Int32
    rows::Int32
    columns::Int32
end

function read_matrix(path::String)::Array{Float64,2}
    stream = open(path)
    h = read_header(stream)
    M = Array{Float64,2}(h.rows, h.columns)
    for col = 1:h.columns
        M[:, col] = read(stream, Float64, h.rows)
    end
    close(stream)
    return M
end

function read_header(stream::IOStream)::MatrixHeader
    h = MatrixHeader(
        read(stream, Int32),
        read(stream, Int32),
        read(stream, Int32),
        read(stream, Int32),
        read(stream, Int32),
        read(stream, Int32)
    )
    return h
end

function read_column(path::String, column::Int64)::Array{Float64,1}
    stream = open(path)
    h = read_header(stream)
    offset = (column - 1) * h.rows * 8
    skip(stream, offset)
    v = read(stream, Float64, h.rows)
    close(stream)
    return v
end

function write_matrix(M::Array{Float64,2}, path::String)
    stream = open(path, "w")
    # version
    write(stream, Int32(1))
    # format
    write(stream, Int32(0))
    # data type
    write(stream, Int32(0))
    # type length
    write(stream, Int32(8))
    rows, cols = size(M)
    write(stream, Int32(rows))
    write(stream, Int32(cols))
    for col = 1:cols
        for row = 1:rows
            write(stream, Float64(M[row, col]))
        end
    end
    close(stream)
end

end # module
