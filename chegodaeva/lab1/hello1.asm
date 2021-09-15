   DOSSEG                                      
   .MODEL  SMALL                             
   .STACK  100h                               
   .DATA                                       
Greeting LABEL BYTE 
DB 'Вас приветствует ст.гр.0382 - Чегодаева Елизавета ','$' 
   .CODE                                
   mov  ax, @data                        
   mov  ds, ax                           
   mov  dx, OFFSET Greeting             
                                        
DisplayGreeting:
   mov  ah, 9                            
   int  21h                             
   mov  ah, 4ch                          
   int  21h                             
   END
