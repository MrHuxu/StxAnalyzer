$V= %w{S' S C}
$T= %w{c d}
$X = $V[1..2]+$T

$line = []
$line[0] = %w{S' -> S}
$line[1] = %w{S -> C C}
$line[2] = %w{C -> c C}
$line[3] = %w{C -> d}

same = []
$first = ($line.length).times.map {[]}     #初始化二维数组
0.upto($line.length - 1) { |i|  
  index_V = $V.find_index($line[i][0])
  2.upto($line[i].length - 1) { |i2|
    if $line[i][i2 - 1] == "->"
      if $V.include?($line[i][i2])
        same[same.length] = [i, $V.find_index($line[i][i2])]
        break;
      elsif $T.include?($line[i][i2])
        $first[index_V][$first[index_V].length] = $line[i][i2]
      end
    end
  }
}

(same.length - 1).downto(0) { |i|  
  $first[(same[i][0])] = $first[(same[i][1])]
}

$pro_l = []
0.upto(300) { |i|  
  $pro_l[i] = []
  0.upto(300) { |i2|  
    $pro_l[i][i2] = []
  }
}
$pla = 0
$numofpro = []
$num = 1

def closure(m)
  tmp_line = []
  j = 0
  while j < $pro_l[$pla].length do
    0.upto($pro_l[$pla][j].length - 1) { |i|  
      if $pro_l[$pla][j][i] == '`'
        nex = i + 1
        if $V.include?($pro_l[$pla][j][nex])
          0.upto($line.length-1) { |i2|  
            if $pro_l[$pla][j][nex] == $line[i2][0]
              tmp_line = $line[i2]
              if $pla == 0
                tmp_line.insert(tmp_line.find_index("->")+1, '`')
                if $V.include?($pro_l[$pla][j][nex+1])
                  0.upto($first[$V.find_index($pro_l[$pla][j][nex+1])].length-1) { |i3| 
                    tmp_line = tmp_line + ['|'] + [$first[$V.find_index($pro_l[$pla][j][nex+1])][i3]]
                  }
                  $pro_l[$pla][$num] = tmp_line
                  $num += 1
                else
                  tmp_line = tmp_line + ['|'] + [$pro_l[$pla][j][$pro_l[$pla][j].length-1]]
                  $pro_l[$pla][$num] = tmp_line
                  $num += 1
                end
              else
                0.upto($pro_l[$pla][j].length-1) { |i3|  
                  if $pro_l[$pla][j][i3] == '|'
                    tmp_line = tmp_line + $pro_l[$pla][j][i3..($pro_l[$pla][j].length-1)]
                    break
                  end
                }
                $pro_l[$pla][$num] = tmp_line
                $num += 1
              end
            end
          }
        end
        break
      end
    }
    j += 1
  end
  $numofpro[$pla] = $num
  $num = 1
end
$pro_l[0][0] = %w{S' -> ` S | $}
closure($pro_l[0][0])

def goto(m)
  $ifrepeat = 0
  point = m.find_index('`')
  if m[point+1] == '|'
    return
  else
    m[point] = m[point + 1]
    m[point + 1] = '`'
    0.upto($pla) { |i|  
      if $pro_l[i][0] == m
        $ifrepeat = 1
      end
    }
    if  $ifrepeat == 1
      $ifrepeat = 0
      return
    end
    $pla += 1
    $pro_l[$pla][0] = m
    $numofpro[$pla] = 1
    if m[m.find_index('`')+1] == '|'
      return
    else
      closure(m)
    end
  end
end

k = 0
while k <= $pla do
  0.upto($numofpro[k] - 1) { |i2|  
    tmp = [] + $pro_l[k][i2]
    goto(tmp)
  }
  k += 1
end
0.upto($pla) { |i|  
  0.upto($numofpro[i] - 1) { |i2|  
    print i, "     ", $pro_l[i][i2],"\n"
  }
  puts "--------------------"
}