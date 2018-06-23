# table_modes

const table_modes = Dict(
    :markdown => TableMode(:markdown; corner_corner = '|', header_fillchar = '-'),
    :grid => TableMode(:grid; corner_corner = '+', header_fillchar = '='),
)

display_style = Dict(
    :table_mode => table_modes[:markdown],
    :prepend_newline => false,
)

function set_table_mode(mode::Symbol)
    display_style[:table_mode] = table_modes[mode]
end
