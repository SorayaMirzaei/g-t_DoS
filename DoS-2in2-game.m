clear all; close all;

sig=0.1;
lambda=0.25;
eta=0.5;

PayOffmatrix_S=zeros(2,2);
PayOffmatrix_B=zeros(2,2);

i=1;
for S=0.0001:0.0001:0.2
    for B=S:0.0001:0.2
        if(B~=0 || S~=0)
            R=1-(B+S);
            PayOffmatrix_S(1,1)=S/(B+S+R*(lambda+sig+1));
            PayOffmatrix_S(1,2)=(S*(1-((eta-lambda)/2))/(B-eta*B+S+R*(lambda+sig+1)));
            PayOffmatrix_S(2,1)=(S-eta*S)/(B+(S-eta*S)+R*(lambda+sig+1));
            PayOffmatrix_S(2,2)=(S-eta*S)*(1-((eta-lambda)/2))/(B-eta*B+S-eta*S+R*(lambda+sig+1));
            
            
            PayOffmatrix_B(1,1)=B/(B+S+R*(lambda+sig+1));
            PayOffmatrix_B(1,2)=((B-eta*B)/(B-eta*B+S+R*(lambda+sig+1)));
            PayOffmatrix_B(2,1)=(B*(1-((eta-lambda)/2)))/(B+(S-eta*S)+R*(lambda+sig+1));
            PayOffmatrix_B(2,2)=(B-eta*B)*(1-((eta-lambda)/2))/(B-eta*B+S-eta*S+R*(lambda+sig+1));
            
            
            %Player 1
            [BR11 BR_index11]=max(PayOffmatrix_S(:,1));
            [br12 BR_index12]=max(PayOffmatrix_S(:,2));
            
            %Player 2
            [BR21 BR_index21]=max(PayOffmatrix_B(1,:));
            [BR22 BR_index22]=max(PayOffmatrix_B(2,:));
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Step 4: Find the Nash Equilibrium(s)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if (BR_index11==BR_index12) %P1 has a strictly dominant strategy
                if (BR_index21==BR_index22) %P2 has a strictly dominant strategy
                    nash=[BR_index11 BR_index21];
                elseif (BR_index21~=BR_index22) %P2 does NOT have a strictly dominant strategy
                    if (BR_index11==1)
                        nash=[BR_index11 BR_index21];
                    elseif (BR_index11==2)
                        nash=[BR_index11 BR_index22];
                    end
                end
            elseif (BR_index11~=BR_index12) %P1 does NOT have a strictly dominant strategy
                if (BR_index21==BR_index22) %P2 has a strictly dominant strategy
                    if (BR_index21==1)
                        nash=[BR_index11 BR_index21];
                    elseif (BR_index21==2)
                        nash=[BR_index12 BR_index21];
                    end
                elseif (BR_index21~=BR_index22) %P2 does NOT have a strictly dominant strategy (nodominant strategies)
                    if (BR_index11==BR_index21)
                        if (BR_index11==1)
                            nash1=[BR_index11 BR_index21];
                        end
       
                    elseif (BR_index11==2)
                        if (BR_index12==1)
                            nash1=[BR_index12 BR_index21];
                        elseif (BR_index12==2)
                            nash1=[0 0];
                        end
                    end
                elseif (BR_index11~=BR_index21)
                    nash1=[0 0];
                end
                if (BR_index12==BR_index22)
                    if (BR_index12==2)
                        nash2=[BR_index12 BR_index22];
                    elseif (BR_index12==1)
                        if (BR_index11==2)
                            nash2=[BR_index11 BR_index22];
                        elseif (BR_index11==1)
                            nash2=[0 0];
                        end
                    end
                elseif (BR_index12~=BR_index22)
                    nash2=[0 0];
                end
                if (nash1==nash2)
                    nash=nash1;
                elseif (nash1~=nash2)
                    nash=[nash1;
                        nash2];
                end
              
            end
            
               Nash{i,1}=nash;
               i=i+1;                    
        end
        
    end
end

 writecell(Nash,'Nash.csv');