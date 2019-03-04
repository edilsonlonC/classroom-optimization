include "Constant.dzn";
include "cumulative.mzn";
set of int :sessions=1..N_sessions; 
set of int :rooms=1..availRooms;
set of int :slots=1..numSlots;
set of int :perday=1..numSlotsPerDay;
set of int :hours=7..18;
array[sessions] of var 1..numSlots:Sessions;
array [sessions] of var 0..Days-1:days;
%array[sessions] of var rooms:Rooms;
array[sessions] of var hours:Hours;

constraint                                    %put sessions in any day
forall(i in sessions)(
days[i]= (Sessions[i] div 12)+1
);
constraint                                    %a group can't take the same session more than twice a day
forall (i,j in sessions where i<j /\ courseGroup[i]=courseGroup[j])
(
 days[i]!=days[j]
);
constraint                                    %put sessions in posible h
forall(i in sessions)
(
 Hours[i]=Sessions[i] mod 12 +7
);
constraint                                    %in order to stablish a lecturer schedule difference in one day was necessary to mention, upon an equal day, the hour must be varied for one 
forall(i,j in sessions where i<j /\ days[i]=days[j]/\lecture[i]=lecture[j])
(Hours[i]!=Hours[j]/\Hours[j]!=Hours[i]+duration[i]);
constraint                                    %break time
forall (i in sessions)
(Hours[i]!=12);
constraint                                    %sessions can't begin one day and over at the next
forall(i in sessions)                         %
(duration[i]+Hours[i]<19);
var rooms:r;
% constraint 
% cumulative(Sessions,duration,many,15);
% solve minimize r;
solve satisfy;

output ["Las horas son: ", "", show(Hours),"\n Los dias son: ", "", show(days),"\n  sesiones : ", "", show(Sessions),"\n salones : ",show(r)];