require 'benchmark'

Benchmark.bm do |bm|
   bm.report("Unpack") do
     1000.times do
       "aabcjksjdsodoiio32j3k2jkjdksjkdsj,,-"[/\S+/].unpack("U*").sort.pack("U*")
     end
   end

   bm.report("Chars") do
     1000.times do
       "aabcjksjdsodoiio32j3k2jkjdksjkdsj,, ,fd,f,d, f,d,,---".gsub(/[,\t\r\n\f]*/, "").chars.sort.join
     end
   end
end


# user     system      total        real
# Unpack  0.020000   0.000000   0.020000 (  0.011228)
# Chars  0.060000   0.000000   0.060000 (  0.058072)

