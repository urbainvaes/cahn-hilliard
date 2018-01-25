#/usr/bin/env gawk

match($0, /(.*)\/(.*)-config.h/, matches) {
    printf "%s/%s\n", matches[1], matches[2]
    printf "#define HERE GITROOT/inputs/%s\n" , matches[1]
    printf "#include xstr(GITROOT/inputs/%s/%s-config.h)\n\n" , matches[1], matches[2]
}

match($0, /(.*)\/config.h/, matches) {
    print matches[1]
    printf "#define HERE GITROOT/inputs/%s\n" , matches[1]
    printf "#include xstr(GITROOT/inputs/%s/config.h)\n\n", matches[1]
}

match($0, /(.*)\/([^\/]*)-config-([[:digit:]])\.h/, matches) {

    # Parse input
    directory = matches[1]
    item = matches[2]
    category_name = matches[3]

    # The categories are specific to one directory
    items[directory][category_name][sizes[directory][category_name]++]=item
}

END {
    for (directory in items) {

        # Total number of combinations that can be constructed from the cotegories
        total_size=1
        for (category in items[directory])
            total_size*=sizes[directory][category]

        # Loop over `length(items[directory])`-dimensional matrix
        for (ind = 0; ind < total_size; ind++) {

            # What remains to be divided
            remainder = ind

            # Auxiliary variable to detect the last element
            aux_ind = 1

            printf "%s", directory
            for (category in items[directory]) {

                divider = sizes[directory][category]
                item_number = remainder%divider
                remainder = (remainder - item_number)/divider

                # Derived variable
                item = items[directory][category][item_number]

                # Set formating depending on iteration number
                # output_format = aux_ind == length(items[directory]) ? "%s" : "%s/"
                printf "/%s", items[directory][category][item_number]
                sources[ind][aux_ind] = sprintf("%s/%s-config-%s.h",directory,item,category)

                aux_ind++
            }
            print ""
            printf "#define HERE GITROOT/inputs/%s\n" , directory
            for (s in sources[ind])
              printf "#include xstr(GITROOT/inputs/%s)\n", sources[ind][s]
            print ""
        }
    }
}
