% Fundamental Matrix Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu

% Returns the camera center matrix for a given projection matrix

% 'Points_a' is nx2 matrix of 2D coordinate of points on Image A
% 'Points_b' is nx2 matrix of 2D coordinate of points on Image B
% 'F_matrix' is 3x3 fundamental matrix

% Try to implement this function as efficiently as possible. It will be
% called repeatly for part III of the project

function [ F_matrix ] = estimate_fundamental_matrix(Points_a,Points_b)

%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%

normalization=0;
%%%%%%%%%%%%Implement Normalization%%%%%%%%%%%%
[m_a,n_a]=size(Points_a);
[m_b,n_b]=size(Points_b);

if normalization==1
	C1=mean(Points_a);
	Cu1=C1(1,1);
	Cv1=C1(1,2);

	C2=mean(Points_b);
	Cu2=C2(1,1);
	Cv2=C2(1,2);

	dist1=0;
	dist2=0;
	for i= 1:m_a
		dist1=dist1+(Points_a(i,1)-Cu1)^2+(Points_a(i,2)-Cv1)^2;
		dist2=dist2+(Points_b(i,1)-Cu2)^2+(Points_b(i,2)-Cv2)^2;
	end

	avg_dist1=dist1/m_a; %RMS distance
	avg_dist2=dist2/m_b; %m_a=m_b

	%%%%%%%Normalize distance to sqrt(2)%%%%%%%
	s1=sqrt(2/avg_dist1);
	s2=sqrt(2/avg_dist2);

	%%%%%%%Normalize distance to sqrt(2)%%%%%%%
	Ta=[s1 0 0; 0 s1 0; 0 0 1] * [1 0 -Cu1; 0 1 -Cv1; 0 0 1];
	Tb=[s2 0 0; 0 s2 0; 0 0 1] * [1 0 -Cu2; 0 1 -Cv2; 0 0 1];

	%%%%%%%Points After Transfer%%%%%%%
	for i=1:m_a
		Points_a_T=transpose(Ta*[Points_a(i,1);Points_a(i,2);1]);
		Points_a(i,:)=Points_a_T(1,1:2);

		Points_b_T=transpose(Tb*[Points_b(i,1);Points_b(i,2);1]);
		Points_b(i,:)=Points_b_T(1,1:2);
	end
end

%%%%%%%%%%%%Implement FMatrix Estimation%%%%%%%%%%%%
A=zeros(m_a,8);
b=-ones(m_a,1);
for i=1:m_a
	u1=Points_a(i,1);
	v1=Points_a(i,2);
	u2=Points_b(i,1);
	v2=Points_b(i,2);
	A(i,1)=u1*u2;
	A(i,2)=v1*u2;
	A(i,3)=u2;
	A(i,4)=u1*v2;
	A(i,5)=v1*v2;
	A(i,6)=v2;
	A(i,7)=u1;
	A(i,8)=v1;
end

F=A\b;
F=[F;1];
F=reshape(F,3,3)';

[U,S,V]=svd(F);
Eigen_Values=sort(max(S,[],2),'descend');
S2=[Eigen_Values(1) 0 0; 0 Eigen_Values(2) 0; 0 0 0];

%%%%%%%F matrix without Normalization%%%%%%%
F_matrix=U*S2*V';

%%%%%%%F matrix with Normalization%%%%%%%
if normalization==1
	F_temp=F_matrix;
	F_matrix=Tb'*F_temp*Ta;
end
        
end

