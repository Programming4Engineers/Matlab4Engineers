function [ t ] = bhaskara(a, b, c )

    t1 = ( -b + sqrt(b*b - 4*a*c) )/(2*a)
    t2 = ( -b - sqrt(b*b - 4*a*c) )/(2*a)
    
    t = max(t1,t2);
end

