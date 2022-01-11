clear all; close all;

sig=0.1;
lambda=0.25;
eta=0.5;

PayOffmatrix_S=zeros(3,3);
PayOffmatrix_B=zeros(3,3);

NashPayoff_S(1,1)=0;
NashPayoff_B(1,1)=0;

for S=0.001:.001:0.2
    for B=S:0.001:0.2
        if(B~=0 || S~=0)
            R=1-(B+S);
            
            %% Fill payoff matrix
            
            PayOffmatrix_S(1,1)=S/(B+S+R);
            PayOffmatrix_S(2,1)=(S+lambda*S)/(S+lambda*S+R*(lambda+sig+1));
            PayOffmatrix_S(3,1)=(S+sig*S)/(B+sig*B+lambda*B+S+sig*S+R*(lambda+sig+1));
            
            PayOffmatrix_S(1,2)=0;
            PayOffmatrix_S(2,2)=0;
            PayOffmatrix_S(3,2)=((S+sig*S)*(1-((eta-lambda)/2))/(B+B*lambda- eta*B+S+sig*S+R*(lambda+sig+1))) ;
            
            PayOffmatrix_S(1,3)=(S+sig*S+lambda*S)/(B+sig*B+S+sig*S+lambda*S+R*(lambda+sig+1));
            PayOffmatrix_S(2,3)=(S+lambda*S- eta*S)/(B+sig*B+S+lambda*S- eta*S+R*(lambda+sig+1));
            PayOffmatrix_S(3,3)=(S+sig*S)/(B+sig*B+S+sig*S+R*(lambda+sig+1));
            
            %---------------------------------------------------------------------
            
            PayOffmatrix_B(1,1)=B/(B+S+R);
            PayOffmatrix_B(2,1)=0;
            PayOffmatrix_B(3,1)=(B+B*sig+lambda*B)/(B+B*sig+lambda*B+S+sig*S+R*(lambda+sig+1));
            
            PayOffmatrix_B(1,2)=(B+lambda*B)/(B+lambda*B+R*(lambda+sig+1));
            PayOffmatrix_B(2,2)=0;
            PayOffmatrix_B(3,2)= (B+lambda*B- eta*B)/(S+sig*S+B+lambda*B- eta*B+R*(lambda+sig+1));
            
            PayOffmatrix_B(1,3)=(B+sig*B)/(B+B*sig+S+sig*S+lambda*S+R*(lambda+sig+1));
            PayOffmatrix_B(2,3)=((B+sig*B)*(1-((eta-lambda)/2))/(B+sig*B+S+lambda*S-eta*S+R*(lambda+sig+1)));
            PayOffmatrix_B(3,3)=(B+sig*B)/(B+B*sig+S+sig*S+R*(lambda+sig+1));
            
            %% Find Nash Equlibrium
            
            [A,B,a,b,iterations,err,ms,s,msp]=bimat(PayOffmatrix_S,PayOffmatrix_B);
            
            
            if(s==1)%The bimatrix game has  Nash equilibria
                [n,~]=size(msp);
                if(n==1)
                    %The bimatrix game has pure Nash equilibria
                    NashPayoff_S(I,J)=msp(1,3); %Player S payoff
                    NashPayoff_B(I,J)=msp(1,4); %Player B payoff
                    I=I+1;
                else
                    %The bimatrix game has multi Nash equilibria then
                    %payoff will be mean of them
                    
                    NashPayoff_S(I,J)=mean(msp(:,3));
                    NashPayoff_S(I,J)=mean(msp(:,4));
                end
            end
            
            if(s==-1)% The bimatrix game has no pure strategy and one mixed strategy Nash Equilibrium
                NashPayoff_S(I,J)=A(1,1)*B(1,1)*PayOffmatrix_S(1,1)+B(1,1)*A(1,2)*PayOffmatrix_S(1,2)+B(1,1)*A(1,3)* PayOffmatrix_S(1,3)...
                    +B(1,2)*A(1,1)*PayOffmatrix_S(2,1)+ B(1,2)*A(1,2)* PayOffmatrix_S(2,2)+B(1,2)*A(1,3)*PayOffmatrix_S(2,2)...
                    +B(1,3)*A(1,1)*PayOffmatrix_S(3,1)+B(1,3)*A(1,2)*PayOffmatrix_S(3,2)+A(1,3)*B(1,3)*PayOffmatrix_S(3,3);
                
                
                NashPayoff_B(I,J)=A(1,1)*B(1,1)*PayOffmatrix_B(1,1)+B(1,1)*A(1,2)*PayOffmatrix_B(1,2)+B(1,1)*A(1,3)* PayOffmatrix_B(1,3)...
                    +B(1,2)*A(1,1)*PayOffmatrix_B(2,1)+ B(1,2)*A(1,2)* PayOffmatrix_B(2,2)+B(1,2)*A(1,3)*PayOffmatrix_B(2,2)...
                    +B(1,3)*A(1,1)*PayOffmatrix_B(3,1)+B(1,3)*A(1,2)*PayOffmatrix_B(3,2)+A(1,3)*B(1,3)*PayOffmatrix_B(3,3);
                I=I+1;
            end
             
        end
    end
end
