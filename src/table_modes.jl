# table_modes

const table_modes = Dict(
    :markdown => TableMode(:markdown; corner_corner = '|', header_fillchar = '-'),
    :grid_tables => TableMode(:grid_tables; corner_corner = '+', header_fillchar = '='),
)

display_style = Dict(
    :table_mode => table_modes[:markdown],
)

function set_table_mode(mode::Symbol)
    display_style[:table_mode] = table_modes[mode]
end
