require_relative 'line'
require_relative 'matrix'
require_relative 'transform'
require_relative 'curve'
require_relative 'solid'
require_relative 'polygon'

def main() # remember to change XRES and YRES
    out = Array.new(YRES) {Array.new(XRES, [0, 0, 0])}
    # transform = ident(4)
    edges = Array.new(0)
    triangles = Array.new(0)
    stack = [ident(4)]
    file_data = []
    # script()
    File.open('script.txt', 'r') {|file|
    # File.open('lol.txt', 'r') {|file|
        file.each_line { |line|
            file_data.append(line.strip)
        }
    }
    while file_data.length > 0 
        current = file_data.shift # pop first element off array
        if current[0] == '#'
            next # continue in python
=begin
        elsif current == 'ident'
=end
            transform = ident(4)
        elsif current == 'scale'
            factors = file_data.shift.split(" ")
            stack[0] = mult(stack[0], scale(*factors))
        elsif current == 'move'
            dists = file_data.shift.split(" ")
            stack[0] = mult(stack[0], trans(*dists))
        elsif current == 'rotate'
            args = file_data.shift.split(" ")
            stack[0] = mult(stack[0], rot(*args))
=begin
        elsif current == 'apply'
            mult(transform, edges)
            mult(transform, triangles)
=end
        elsif current == 'display'
            # out = Array.new(YRES) {Array.new(XRES, [0, 0, 0])}
            # draw_matrix(out, edges, 0)
            # draw_matrix(out, triangles, 1)
            save_ppm(out, XRES, YRES)
            `display image.ppm` # ` ` runs terminal commands
        elsif current == 'save'
            out_file = file_data.shift
            # out = Array.new(YRES) {Array.new(XRES, [0, 0, 0])}
            # draw_matrix(out, edges, 0)
            # draw_matrix(out, triangles, 1)
            save_ppm(out, XRES, YRES)
            `convert image.ppm #{out_file}`
        elsif current == 'line'
            coords = file_data.shift.split(" ")
            add_edge(edges, *(coords.map {|x| x.to_f}))
            mult(stack[0], edges)
            draw_matrix(out, edges, 0)
            edges.clear
        elsif current == 'circle'
            args = file_data.shift.split(" ")
            args.map! {|x| x.to_f} # ! actually replaces the array
            add_circle(edges, *args) 
            mult(stack[0], edges)
            draw_matrix(out, edges, 0)
            edges.clear
        elsif current == 'hermite'
            args = file_data.shift.split(" ")
            args.map! {|x| x.to_f}
            add_hermite(edges, *args)
            mult(stack[0], edges)
            draw_matrix(out, edges, 0)
            edges.clear
        elsif current == 'bezier'
            args = file_data.shift.split(" ")
            args.map! {|x| x.to_f}
            add_bezier(edges, *args)
            mult(stack[0], edges)
            draw_matrix(out, edges, 0)
            edges.clear
=begin
        elsif current == 'clear'
            edges.clear
            triangles.clear
=end
        elsif current == 'box'
            args = file_data.shift.split(" ")
            args.map! {|x| x.to_f}
            add_box(triangles, *args)
            mult(stack[0], triangles)
            draw_matrix(out, triangles, 1)
            triangles.clear
        elsif current == 'sphere'
            args = file_data.shift.split(" ")
            args.map! {|x| x.to_f}
            add_sphere(triangles, 20, *args)
            mult(stack[0], triangles)
            draw_matrix(out, triangles, 1)
            triangles.clear
        elsif current == 'torus'
            args = file_data.shift.split(" ")
            args.map! {|x| x.to_f}
            add_torus(triangles, 20, *args)
            mult(stack[0], triangles)
            draw_matrix(out, triangles, 1)
            triangles.clear
        elsif current == 'push'
            stack.unshift(stack[0].map {|x| x})
        elsif current == 'pop'
            stack.shift
        end
    end
end

def save_ppm(ary, xdim, ydim)
    File.open('image.ppm', 'w') {|file|
        file.write("P3\n#{xdim}\n#{ydim}\n255\n")
        ary.length.times {|i|
            ary[i].length.times{|j|
                3.times {|k|
                    # puts "#{i} #{j} #{k}"
                    file.write(ary[i][j][k].to_s + ' ')
                }
            }
        }
    }
end

def script()
    stuff = [100, 200, 300, 400, 500]
    File.open('script.txt', 'w') {|file|
        stuff.length.times {|x|
            x.times {|y|
                file.write("bezier\n")
                file.write("#{stuff[y]} 0 #{stuff[x]} #{stuff[x]} 0 #{stuff[y]} 0 0\n")
                file.write("hermite\n")
                file.write("0 #{stuff[y]} #{stuff[x]} #{stuff[x]} 100 100 -100 100\n")
            }
        }
        file.write("display\n")
        file.write("save\nimage.png")
    }
end

main()
