function [D_h,D_l,P,Q,err1,err2] = ADMM_Coupled_DL(params,varargin)


%%%%% parse input parameters %%%%%
data1 = params.data1;
data2=  params.data2;

% initialize the dictionary %
dictsize=params.dictsize;
idx=randperm(size(data1,2));
data1=data1(:,idx);
data2=data2(:,idx);

D_h(:,1:dictsize) = data1(:,1:dictsize); 
D_l(:,1:dictsize) = data2(:,1:dictsize); 

  % % normalize the dictionary %
D_h = D_h*diag(1./sqrt(sum(D_h.*D_h))); 
D_l = D_l*diag(1./sqrt(sum(D_l.*D_l))); 
    
c1=0.4;
c2=0.4;
c3 =0.8;
maxbeta= 10^6; % Set the maximum mu

delta=1e-4;
beta=0.01;

W_h = randn(params.dictsize,size(data1,2)); 
W_l = randn(params.dictsize,size(data2,2)); 

Y1=zeros(size(W_h));Y2=zeros(size(W_h));Y3=zeros(size(W_h));
I = eye(dictsize,dictsize);

 P= W_h;
 Q = W_l;

iternum=params.iternum;

%%%%%%%%%%%%%%%%%  main loop  %%%%%%%%%%%%%%%%
for iter = 1:iternum
  

% update W_h and W_l 
  W_h= (D_h'*D_h + c1 * I + c3* I) \ (D_h' * data1 + Y1-Y3+c1*P + c3* W_l) ; 

  W_l= (D_l'*D_l + c2 * I + c3* I) \ (D_l' * data2 + Y2-Y3+c2*Q + c3* W_h) ; 
 
  for xx=1:size(data1,2)
      y_1=( W_h(:,xx) - Y1(:,xx)/c1 );
      y_1 = y_1 ./norm(y_1(:));
      y_2=(  W_l(:,xx) - Y2(:,xx)/c2);
      y_2 = y_2 ./norm(y_2(:));

      tmp_1= soft_thresh(y_1,0.2);     
      
%        tmp_1=SolveLasso(D_h, y_1, size(D_h,2),'nnlasso' ,0.1);

      
      P(:,xx)=tmp_1;

      tmp_2= soft_thresh(y_2,0.2);  
%        tmp_2=SolveLasso(D_l, y_2, size(D_l,2),'nnlasso' ,0.1);

      Q(:,xx)=tmp_2;
      
  end
  
     for j = 1:dictsize
      
        phi_1=W_h(j,:)*W_h(j,:)';  
        phi_2=W_l(j,:)*W_l(j,:)';
        D_h(:,j)=  D_h(:,j) +  (  data1*W_h(j,:)') / (phi_1+delta);   
  
        D_l(:,j)=  D_l(:,j) +   ( data2*W_l(j,:)') / (phi_2+delta);


    end
    D_h = D_h*diag(1./sqrt(sum(D_h.*D_h))); 
    D_l = D_l*diag(1./sqrt(sum(D_l.*D_l))); 


Y1=Y1+c1*min(maxbeta, beta*c1)*(P-W_h);
Y2=Y2+c2*min(maxbeta, beta*c2)*(Q-W_l);
Y3=Y3+c3*min(maxbeta, beta*c3)*(W_h - W_l);
err1(iter)= sqrt(sum(sum((data1-D_h*W_h).^2))/numel(data1)); 
err2(iter)= sqrt(sum(sum((data2-D_l*W_l).^2))/numel(data2)); 

info=sprintf('Iteration %d / %d complete', iter, iternum);
info=sprintf('%s, %s = %.10g', info, 'RMSE', err1(iter));
info=sprintf('%s, %s = %.10g', info, 'RMSE', err2(iter));
disp(info);


end


end