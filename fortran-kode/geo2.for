           
           
           PROGRAM GEO2

C*******************************************************************
C     WRITE(*,*) BEREGNING AV GEODETISK LINJE FRA PUNKT 1 TIL
C     WRITE(*,*) PUNKT 2 OG ASIMUT FOR LINJEN I 1 OG I 2.     
C     WRITE(*,*) KOORDINATENE (B1,L1) OG (B2,L2) ER GITT.
C     WRITE(*,*)       J.H. JUNI90
C*******************************************************************
        
      IMPLICIT LOGICAL(A-Z)
      INTEGER P

      REAL*8 A,B,B1,L1,B2,L2,B3,BE1,BE2,BE3,M1,M2,M3,N1,N2,N3
      REAL*8 R1,R2,R3,X1,X2,X3,S,S1,PI,RO,A1,A2,A3

      PI=DATAN(1)*4.D0
      RO=PI/180.D0

      WRITE(*,*)'LEGG INN GEOGRAFISKE KOORDINATER B1,L1,B2,L2:'
      READ(*,*) B1,L1,B2,L2
      B1=B1*RO
      L1=L1*RO
      B2=B2*RO
      L2=L2*RO
      B3=(B1+B2)/2
            
      WRITE(*,*) 'VALG AV ELLIPSOIDE.P SETTES LIK 1 FOR :'
      WRITE(*,*) 'NORSK BESSELS ,LIK 2 FOR INTERNASJONAL:'
      WRITE(*,*) 'OG LIK 3 FOR FOR WGS-84-ELLIPSOIDEN:'
      WRITE(*,*) 'LEGG INN P:'
      READ(*,*) P
      
                 CALL AKSER(P,A,B)
      
      BE1=DATAN(B*DTAN(B1)/A)
      BE2=DATAN(B*DTAN(B2)/A)
      BE3=DATAN(B*DTAN(B3)/A)

C********** BEREGNING AV GEOSENTRISK DELTA X,DELTAY,DELTA Z

      X1=A*(DCOS(BE2)*DCOS(L2)-DCOS(BE1)*DCOS(L1))
      X2=A*(DCOS(BE2)*DSIN(L2)-DCOS(BE1)*DSIN(L1))
      X3=B*(DSIN(BE2)-DSIN(BE1))

C********* BEREGNING AV A1 OG A2

           CALL ASIMUT(X1,X2,X3,B1,L1,A1)
                 X1=-X1
                 X2=-X2
                 X3=-X3                           
                           
           CALL ASIMUT(X1,X2,X3,B2,L2,A2)
       
           
                 A3=(A1+A2-PI)/2.D0


C********* KORDEN S
                     
      S=SQRT(X1**2.D0+X2**2.D0+X3**2.D0)
                                 
           CALL KRRAD(A,B,B1,BE1,A1,M1,N1,R1)
           CALL KRRAD(A,B,B2,BE2,A2,M2,N2,R2)
           CALL KRRAD(A,B,B3,BE3,A3,M3,N3,R3)

            R3=(R1+R2+4.D0*R3)/6.D0
       
C********* KORDEN KORRIGERES TIL GEODETISK LINJE

      S1=S+S**3.D0/(24.D0*R3**2.D0)
      S1=S+S1**3.D0/(24.D0*R3**2.D0)
      S1=S+S1**3.D0/(24.D0*R3**2.D0)-S1**5/(1920*R3**4)
      
      A1=A1/RO
      A2=A2/RO
                                         
           
      WRITE(*,*)'ASIMUT A1:'
      WRITE(*,110) 'A1:',A1
      WRITE(*,*)'ASIMUT A2:'
      WRITE(*,110) 'A2:',A2
      
      WRITE(*,*)'GEODETISK LINJE:'
      WRITE(*,*)
      WRITE(*,200) 'S1:',S1

  100 FORMAT(1X,A,$)
  110 FORMAT(1X,A,F14.9)
  200 FORMAT(1X,A,F14.3)

      STOP
      
      END
                
                SUBROUTINE AKSER(P,A,B)

      INTEGER P
      REAL*8 A,B      
                           
      IF(P.EQ.1)THEN
        A=6377492.018D0
        B=6356173.509D0
                RETURN
      
                ELSEIF(P.EQ.2)THEN
        A =6378388.000D0
        B =6356911.946D0    
                RETURN
  
                ELSEIF(P.EQ.3)THEN
        A=6378137.000D0
        B=6356752.314D0
                RETURN
      
      ENDIF
    
      END

                 SUBROUTINE ASIMUT(X1,X2,X3,B1,L1,A1)
       
           
      REAL*8 X1,X2,X3,B1,L1,A1,T,N,PI

      T=-X1*DSIN(L1)+X2*DCOS(L1)
      N=-X1*DSIN(B1)*DCOS(L1)-X2*DSIN(B1)*DSIN(L1)+X3*DCOS(B1)
              
      PI=DATAN(1)*4.D0
      IF(ABS(T).LT.5D-9.AND.N.GT.0)THEN
             A1=0
             RETURN
      ELSEIF(T.GT.0.AND.ABS(N).LT.5D-9)THEN
             A1=PI/2.D0
             RETURN
      ELSEIF(T.LT.0.AND.ABS(N).LT.5D-9)THEN
             A1=1.5D0*PI

             RETURN
      ELSEIF(ABS(T).LT.5D-9.AND.N.LT.0)THEN
             A1=PI
             RETURN
      ENDIF
             
      A1=DATAN(T/N)
      
      IF(T.GT.0.AND.N.GT.0)THEN
         A1=A1            
      RETURN
      ELSEIF(T.GT.0.AND.N.LT.0)THEN
      
         A1=A1+PI
      RETURN
      ELSEIF(T.LT.0.AND.N.LT.0)THEN
         A1=A1+PI
      RETURN
                     
      ELSE
         A1=A1+PI*2.D0
      RETURN
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    