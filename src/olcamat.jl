module olcamat

struct MatrixHeader
    version::Int32
    format::Int32
    dataType::Int32
    typeLength::Int32
    rows::Int32
    columns::Int32
end

struct TechIndexEntry
    process_id::String
    process_name::String
    process_type::String
    process_location::String
    flow_id::String
    flow_name::String
    flow_type::String
    flow_location::String
    flow_property_id::String
    flow_property_name::String
    unit_id::String
    unit_name::String
end

struct EnviIndexEntry
    flow_id::String
    flow_name::String
    flow_type::String
    flow_location::String
    flow_property_id::String
    flow_property_name::String
    unit_id::String
    unit_name::String
end

function read_tech_index(path::String)::Vector{TechIndexEntry}
    stream = open(path)
    records = readdlm(stream, ',', String)
    rows, columns = size(records)
    entries = Vector{TechIndexEntry}(rows - 1)
    for row = 2:rows
        record = records[row, :]
        i = parse(Int, record[1]) + 1
        entries[i] = TechIndexEntry(
            record[2],
            record[3],
            record[4],
            record[5],
            record[6],
            record[7],
            record[8],
            record[9],
            record[10],
            record[11],
            record[12],
            record[13])
    end
    close(stream)
    return entries
end

function read_envi_index(path::String)::Vector{EnviIndexEntry}
    stream = open(path)
    records = readdlm(stream, ',', String)
    rows, columns = size(records)
    entries = Vector{EnviIndexEntry}(rows - 1)
    for row = 2:rows
        record = records[row, :]
        i = parse(Int, record[1]) + 1
        entries[i] = EnviIndexEntry(
            record[2],
            record[3],
            record[4],
            record[5],
            record[6],
            record[7],
            record[8],
            record[9])
    end
    close(stream)
    return entries
end

function read_matrix(path::String)::Array{Float64,2}
    stream = open(path)
    h = read_matrix_header(stream)
    M = Array{Float64,2}(h.rows, h.columns)
    for col = 1:h.columns
        M[:, col] = read(stream, Float64, h.rows)
    end
    close(stream)
    return M
end

function read_matrix_header(stream::IOStream)::MatrixHeader
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
    h = read_matrix_header(stream)
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
