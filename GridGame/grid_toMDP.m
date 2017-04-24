function [P,R]= grid_toMDP(grid, prb)

sz = size(grid,1)-2;
P = zeros(sz*sz, sz*sz, 4 );
R = zeros(sz*sz, 4 );

% left = 1
% right = 2
% up = 3
% down = 4

for i =1:sz
    for j=1:sz
        
        % @grid(i+1,j+1)
        if ( grid(i+1,j+1) == -1 || grid(i+1,j+1) == 1)
            % blocked position
            P ( (i-1)*sz+j, (i-1)*sz+j, :) = 1.0;
            continue;
        end
        
            
        [B,s]= grid_eval ( grid, i+1, j+1 );
        
         R( (i-1)*sz+j, 1 ) = grid(i+1,j);
         R( (i-1)*sz+j, 2 ) = grid(i+1,j+2);
         R( (i-1)*sz+j, 3 ) = grid(i,j+1);
         R( (i-1)*sz+j, 4 ) = grid(i+2,j+1);
        
        % LEFT
        if B(1) == 0
            % BLOCKED
            P( (i-1)*sz+j, (i-1)*sz+j, 1 ) = prb;
            p = (1-prb)/(s);
        else
            P( (i-1)*sz+j, (i-1)*sz+j-1, 1 ) = prb;
            p = (1-prb)/(s-1);
        end
        
        if ( j < sz )
            P ( (i-1)*sz+j, (i-1)*sz+j+1, 1 ) = B(2)*p;
        end
        if ( i > 1 )
            P ( (i-1)*sz+j, (i-2)*sz+j, 1) = B(3)*p;
        end
        if ( i < sz )
            P ((i-1)*sz+j, (i)*sz+j, 1 ) = B(4)*p;
        end
            
        % RIGHT
        if B(2) == 0
            % BLOCKED
            P( (i-1)*sz+j, (i-1)*sz+j, 2 ) = prb;
            p = (1-prb)/(s);
        else
            P( (i-1)*sz+j, (i-1)*sz+j+1, 2 ) = prb;
            p = (1-prb)/(s-1);
        end
        
        if ( j > 1 )
            P ( (i-1)*sz+j, (i-1)*sz+j-1, 2 ) = B(1)*p;
        end
        if ( i > 1 )
            P ( (i-1)*sz+j, (i-2)*sz+j, 2) = B(3)*p;
        end
        if ( i < sz )
            P ((i-1)*sz+j, (i)*sz+j, 2 ) = B(4)*p;
        end
        
        % UP
        if B(3) == 0
            % BLOCKED
            P( (i-1)*sz+j, (i-1)*sz+j, 3 ) = prb;
            p = (1-prb)/(s);
        else
            P( (i-1)*sz+j, (i-2)*sz+j, 3 ) = prb;
            p = (1-prb)/(s-1);
        end
        
        if ( j > 1 )
            P ( (i-1)*sz+j, (i-1)*sz+j-1, 3 ) = B(1)*p;
        end

        if ( j < sz )
            P ( (i-1)*sz+j, (i-1)*sz+j+1, 1 ) = B(2)*p;
        end

        if ( i < sz )
            P ((i-1)*sz+j, (i)*sz+j, 3 ) = B(4)*p;
        end
        
        
        % DOWN
        if B(4) == 0
            % BLOCKED
            P( (i-1)*sz+j, (i-1)*sz+j, 4 ) = prb;
            p = (1-prb)/(s);
        else
            P( (i-1)*sz+j, (i)*sz+j, 4 ) = prb;
            p = (1-prb)/(s-1);
        end
        
        if ( j > 1 )
            P ( (i-1)*sz+j, (i-1)*sz+j-1, 4 ) = B(1)*p;
        end

        if ( j < sz )
            P ( (i-1)*sz+j, (i-1)*sz+j+1, 4 ) = B(2)*p;
        end

        if ( i > 1 )
            P ( (i-1)*sz+j, (i-2)*sz+j, 4) = B(3)*p;
        end
        
    end
end