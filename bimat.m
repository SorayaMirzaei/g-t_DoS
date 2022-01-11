 function [A,B,a,b,iterations,err,ms,s,mps]=bimat(M,N)
    C=M+N;[m,n]=size(C);u=[];v=[];a=[];b=[];count=0;ms=[];mps=[];
    s=-1;
    for i=1:m
        for j=1:n
            if (M(i,j)==max(M(:,j)) && N(i,j)==max(N(i,:)))
               count=count+1;u(count)=i;v(count)=j;a(count)=M(i,j);b(count)=N(i,j);
            end
        end
    end
    if count>0
        for i=1:count
             ms=[ms ' (A' int2str(u(i)) ',B' int2str(v(i)) ') with payoff to Ist player=' num2str(a(i)) ' and payoff to IInd player=' num2str(b(i)) ';'];
             mps(i,1)=u(i);  
             mps(i,2)=v(i);
             mps(i,3)=a(i);
             mps(i,4)=b(i);
        end
        ms=['The bimatrix game has pure Nash equilibria as:-' ms];
        s=1;
    else
        ms=['The bimatrix game has no pure strategy Nash Equillibrium;'];
    end
    ms=[ms ' And one mixed strategy Nash Equilibrium is given in the solution matrix.'];
    H=-[zeros(m,m) C zeros(m,2);C' zeros(n,n+2);zeros(2,n+m+2)];
    f=[zeros(m+n,1);1;1];
    Aeq=[ones(1,m) zeros(1,n+2); zeros(1,m) ones(1,n) zeros(1,2)];
    beq=[1;1];b=zeros(m+n,1);
    A=[zeros(m,m) M -ones(m,1) zeros(m,1); N' zeros(n,n+1) -ones(n,1)];
    lb=[zeros(m+n,1);-inf;-inf];ub=[ones(m+n,1);inf;inf];options=optimset('Largescale','off','MaxIter',500);warning off all;
    [x,fval,exitflag,output,lambda]= quadprog(H,f,A,b,Aeq,beq,lb,ub);X=roundn((x(1:m,1))',-6);Y=roundn((x(m+1:m+n,1))',-6);f=roundn(fval,-6);
    switch exitflag
        case 1
            if abs(fval)<.05
                A=abs(X);B=abs(Y);iterations=output.iterations;a=roundn(x(m+n+1,1),-6);b=roundn(x(m+n+2,1),-6);err=abs(f);
                ms=[ms ' Also we mention that the mixed strategy solution is reasonably relevent!'];
            else
                A=abs(X);B=abs(Y);iterations=output.iterations;a=roundn(x(m+n+1,1),-6);b=roundn(x(m+n+2,1),-6);err=abs(f);
                ms=[ms 'Also we mention that the mixed strategy solution is not reasonably relevent!'];
            end
        case 4
            A=abs(X);B=abs(Y);iterations=output.iterations;a=roundn(x(m+n+1,1),-6);b=roundn(x(m+n+2,1),-6);err=abs(f);
             ms=[ms 'Also we mention that local minimizer was found!'];
        case 0
            A=abs(X);B=abs(Y);iterations=output.iterations;a=roundn(x(m+n+1,1),-6);b=roundn(x(m+n+2,1),-6);err=abs(f);
             ms=[ms 'Also we mention that the number of iterations is too large so the iteration scheme is not easily converging!'];
        case -2
            A=zeros(1,m);B=zeros(1,n);iterations=0;a=0;b=0;err=0;
            ms=['The optimization problem is infeasible!'];
        case -3
            A=zeros(1,m);B=zeros(1,n);iterations=0;a=0;b=0;err=0;
            msgn=['The optimization problem is unbounded!'];
        case -4
            A=zeros(1,m);B=zeros(1,n);iterations=0;a=0;b=0;err=0;
            ms=['The optimization current search direction was not a descent direction. No further progress could be made.'];
        case -7
            A=zeros(1,m);B=zeros(1,n);iterations=0;a=0;b=0;err=0;
            ms=['In the optimization process magnitude of search direction became too small. No further progress could be made.'];
        otherwise
            A=zeros(1,m);B=zeros(1,n);iterations=0;a=0;b=0;err=0;
            ms=['The optimization problem has unexpected error!'];
    end
    
