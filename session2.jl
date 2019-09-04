
#Calling JuMP and the solver
using JuMP
using Gurobi

#Creating the model and specifying the solver 
Ex_1 = Model(with_optimizer(Gurobi.Optimizer));

#Creating the variables and attaching them to the model
@variable(Ex_1,x>=0);
@variable(Ex_1,y>=0);

#Creating the objective and attaching them to the model
@objective(Ex_1, Max, 5x+3*y);

#Creating the constraint and attaching them to the model
@constraint(Ex_1, x+y<=3);

#Solving the problem
optimize!(Ex_1);

#The termination_status tells us what is the status of the resulting solution:
#Optimal/infeasible/unbounded/Time_limit reached
status = termination_status(Ex_1);

#objective_value gives
#the objective function value if the solution is optimal and 0/∞ if infeasible/unbounded
obj_value = objective_value(Ex_1);


#getting the value of the decision variables x and y
x_value = value(x);
y_value = value(y);
println("=======================================")
println("=======================================")
println("Status = ", status)
println("Optimal objective value = ", obj_value)
println("Optimal x value = ", x_value)
println("Optimal y value = ", y_value)

Ex_2 = Model(with_optimizer(Gurobi.Optimizer));
@variable(Ex_2,x[1:2]>=0);
@variable(Ex_2,y[1:2]>=0);
@objective(Ex_2, Min, 2x[1]+3x[2]+7y[1]+12y[2]);
@constraint(Ex_2, x[1]+x[2]<=100);
@constraint(Ex_2, 2x[1]+6x[2]+y[1]>=186);
@constraint(Ex_2, 3x[1]+3x[2]+y[2]>=166.5);
optimize!(Ex_2);
status = termination_status(Ex_2);
obj_value = objective_value(Ex_2);

#The only different here is that we add <.> after value, to specify that x and y are vector
x_value = value.(x);
y_value = value.(y);
println("=======================================")
println("=======================================")
println("Status = ", status)
println("Optimal objective value = ", obj_value)
println("Optimal x value = ", x_value)
println("Optimal y value = ", y_value)

#CSV and DataFrames packages used to import data files to julia
using CSV
using DataFrames

#reading the problem data to Julia
data = CSV.read("Ex3_data.csv");

#converting the DataFrame-type variable (data) to a Matrix
c = convert(Matrix{Float64}, data);

#specifying the problem data
N = size(data)[1];
s=1;
d=N;

#########################################
Ex_3 = Model(with_optimizer(Gurobi.Optimizer));
@variable(Ex_3,x[1:N,1:N]>=0);
@objective(Ex_3, Min, sum(sum(c[i,j]*x[i,j] for i=1:N) for j=1:N));
for i=1:N
    if i != s && i != d
        @constraint(Ex_3, sum(x[i,j] for j=1:N)-sum(x[j,i] for j=1:N) == 0);
    elseif i == s
        @constraint(Ex_3, sum(x[i,j] for j=1:N)-sum(x[j,i] for j=1:N) == 1);
    elseif i == d
        @constraint(Ex_3, sum(x[i,j] for j=1:N)-sum(x[j,i] for j=1:N) == -1);
    end
end
optimize!(Ex_3);
status = termination_status(Ex_3);
obj_value = objective_value(Ex_3);
x_value = value.(x);
println("=======================================")
println("=======================================")
println("Status = ", status)
println("Optimal objective value = ", obj_value)
#println("Optimal x value = ", x_value)

#Ligth Graphs and GraphsPlots are just for plotting the graphs 
using LightGraphs
using GraphPlot
#initializing an adjacency Matrix
adj = zeros(N,N);
for i=1:N
    for j=1:N 
        #for the sake of presentation only add arcs which have values smaller than 2800
        if c[i,j] > 0 && c[i,j] > 2800
            adj[i,j] = 1
        end
    end
end
#Define a directed Graph using the adjacency list
NatPark = DiGraph(adj);

#Numbering the nodes
node_label = [1:nv(NatPark)]
gplot(NatPark,layout=stressmajorize_layout, nodelabel=node_label[1])

#Given a starting_city and destination_city what is the shortest path?
function All_Shortest_paths(distances,starting_city,destination_city)
    c = distances;
    s=starting_city;
      d=destination_city;
    #########################################
    SP = Model(with_optimizer(Gurobi.Optimizer, OutputFlag=0));
    @variable(SP, x[i=1:N,j=1:N; 0<c[i,j]<1000]>=0);
    @objective(SP, Min, sum(sum(c[i,j]*x[i,j] for i=1:N if 0<c[i,j]<1000) for j=1:N));
        for i=1:N
        if i != s && i != d 
            @constraint(SP, sum(x[i,j] for j=1:N if 0<c[i,j]<1000)-sum(x[j,i] for j=1:N if 0<c[j,i]<1000) == 0);
        elseif i == s
            @constraint(SP, sum(x[i,j] for j=1:N if 0<c[i,j]<1000)-sum(x[j,i] for j=1:N if 0<c[j,i]<1000) == 1);
        elseif i == d
            @constraint(SP, sum(x[i,j] for j=1:N if 0<c[i,j]<1000)-sum(x[j,i] for j=1:N if 0<c[j,i]<1000) == -1);
        end
    end
    optimize!(SP);
    status = termination_status(SP);
    obj_value = objective_value(SP);
    x_value = value.(x);
    status, obj_value, x_value
end

solutions = [];
distances = c;
#Use the function to find the shortest path between every pair of parks
for s=1:N
    for d=1:N
        if s!=d
            starting_city = s
            destination_city = d
            status, obj_value, x_value = All_Shortest_paths(distances,starting_city,destination_city);
            push!(solutions,[(s,d),status,obj_value,x_value])
        end
    end
end

#Rearranging the data for the output
p = [];
distances = zeros(N,N)
paths = Array{Any,2}(undef,N,N);
for k=1:length(solutions)
temp = zeros(N,N);
    for i=1:N
        for j =1:N
            if 0<c[i,j]<1000
                temp[i,j] = solutions[k][4][i,j]
            end
        end
    end
    solutions[k][4] = temp
end

for s=1:N
    for d=1:N
        if s != d
            indx = findfirst(x -> (s,d)==x[1], solutions)
            city = s;
            cost = 0;
            Route = [];
            check = findfirst(x -> x >= 1-1e-6 && 0<x<1000, c[s,:])
            while true 
                push!(Route,city);
                next = findfirst(x -> x >= 1-1e-6, solutions[indx][4][city,:])
                if next == nothing 
                    break
                end
                local_cost = c[city,next];
                cost += local_cost
                city = next;
                
                if city == d
                    push!(Route,city);
                    break
                end
            end
            push!(Route,d);
            distances[s,d] = cost;
            paths[s,d] = Route;
        end
    end
end
distances = distances.*0.621371;
push!(p,distances);
push!(p,paths);

RawData = CSV.read("data.csv", header=true); 
names = RawData[!,1];
names = convert(Array{String}, names);

# Pretty Print function
function printDistanceandPath(start,dest)
    s=findfirst(x -> x == start ,names)
    d=findfirst(x -> x == dest ,names)
    println("s =", s)
    println("d = ", d)
    if s==nothing
        println("Invalid starting point")
        return
    end
    
    if d==nothing
        println("Invalid destination")
        return
    end
    
    indx = findfirst(x -> (s,d)==x[1], solutions)
    
   println("The shortest path from ",names[s]," to ",names[d]," is:")
   for i in p[2][s,d]
        println(names[i])
    end
    println("The path is ",p[1][s,d]," miles long.")
end


