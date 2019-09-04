
#scalar type variables
#assign the value 4 to the variable x ==> x is is an integer
x=4

#assign the letter 'a' to the variable y ==> y is is a character
y= 'a'

#assign the sentence "Hello world!" to the variable w ==> w is is a string
w = "Hello world!"

#assign the expression <true> to the variable z ==> z is is a Bool
z = true

#Checking the type of each variable
println("x is ", typeof(x))
println("y is ", typeof(y))
println("w is ", typeof(w))
println("z is ", typeof(z))


#One Dimensionals Arrays
#coloumn vector with integer values
c1 = [1; 2; 3]

#coloumn vector with Float values
c2 = [0.5; 1.0; 1.5]

#coloumn vector with character values
c3 = ['a'; 'b'; 'c']

#coloumn vector with String values
c4 = ["one"; "two"; "three"]

#coloumn vector with Bool values
c5 = [true; false; true; false]

#Checking the type of each vector
println("c1 is ", typeof(c1))
println("c2 is ", typeof(c2))
println("c3 is ", typeof(c3))
println("c4 is ", typeof(c4))
println("c5 is ", typeof(c5))

#One Dimensionals Arrays (Cont.)
#initializing vectors with specific values

#coloumn vectors with three zeros
c_zeros = zeros(3)

#coloumn vectors with three ones
c_ones = ones(3)

#coloumn vectors with three trues
c_trues = trues(3)


#Checking the values of each vector
println("c_zeros = ", c_zeros)
println("c_ones = ", c_ones)
println("c_trues = ", c_trues)


#Multi Dimensionals Arrays
#Matrix with integer values
A1 = [1 10 100;
      2 20 200;
      3 30 300]

#Matrix with Float values
A2 = [0.5 0.5 0.5;
      1.0 1.0 1.0;
      1.5 1.5 1.5]

#Matrix with character values
A3 = ['a' 'e' 'f';
      'b' 'g' 'h';
      'c' 'i' 'j']

#Matrix with String values
A4 = ["one" "hundred" "thousand";
      "two" "two hundred" "two thousand";
      "three" "three hundred" "three thousand"]

#Matrix with Bool values
A5 = [true false; 
      true false]

#Checking the type of each vector
println("A1 is ", typeof(A1))
println("A2 is ", typeof(A2))
println("A3 is ", typeof(A3))
println("A4 is ", typeof(A4))

println("==============================")
println("==============================")

#Checking the values of each vector
println("A1 =", A1)
println("A2 =", A2)
println("A3 =", A3)
println("A4 =", A4)


#Multi Dimensionals Arrays (Cont.)
#initializing Matrices with specific values

#3×3 Matrix with zeros
A_zeros = zeros(3,3)

#2×3 Matrix with  ones
A_ones = ones(2,3)

#3×2 Matrix with trues
A_trues = trues(3,2)

println("A_zeros = ", A_zeros)
println("A_ones = ", A_ones)
println("A_trues = ", A_trues)


#accessing elements 
i =2;
j =3;
#accessing the ith element in the coloumn vector c1
println("the ith element of c1 is = ", c1[i])
println("the element in the ith row and jth coloumn of A1 = ", A1[i,j])

#Other ways to define arrays/Matrices
A_undef = Array{Int64,2}(undef,0,0)
A_fill = fill("abc",2,3)
println("A_undef = ", A_undef)
println("A_fill = ", A_fill)

#Controling the flow 

#increment x by 1 5 times 
#using for loops 
println("using for loops")
x = 0;
for i=1:5
    x +=1
    println("x = ", x)
end
println("====================================")

#using while loops
println("using while loops")
x = 0;
while x < 5 
    x +=1
    println("x = ", x)
end
println("====================================")
#increment x by 1 until the first even number that is greater 10
println("increment x by 1 until the first even number that is greater 10")
x = 0;
y = 1
while true
    x +=1
    y *=x 
    println("x = ", x)
    if x > 10 && iseven(x) 
        break
    else
        continue
    end
end

#functions 

#inline functions f(x) = x²+√x
f(x) = x^2 + sqrt(x);
println("using the inline function f(3) = ", f(3))
println("====================================")


#generic function 
function myfunction(x,y,z)
    u=y^2;
    v = x+z;
    return u, v
end 
println("using the generic function callled myfunction")
x = 3;
z = 5;
z = pi
u , v = myfunction(x,y,z)
println("====================================")


#anonymous function 
#filter the vector a and keep only the elements which are smaller than 4
a = [1 2 3 4 5];
println("old a is  =", a)
a = filter(x -> x <4,a);
println("filtered a is = ", a)




