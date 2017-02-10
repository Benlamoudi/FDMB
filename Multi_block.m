function HIST = Multi_block(img,num_blk,mapp);
[m,n] = size(img);
HIST = [];
        H = floor(m/num_blk);
        W = floor(n/num_blk);        
        HL = mod(m,H);
        WL = mod(n,W);        
        for mm = 1:H:m-HL
            for nn = 1:W:n-WL
                X = img(mm:mm+H-1,nn:nn+W-1,:);
                %bsifdescription=hist(X(:),1:(2^numScl));
                %histnorm = lbp(X,radius,sampling,mapping,'nh');clear X;
				%h = imhist(X);clear X;
                h = hist(X(:),1:mapp);
                HIST = [HIST reshape(h,1,[])];
            end
        end