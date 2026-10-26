; Copyright New Generation Software 1984, 2026 ArcadeGeek LTD.
; NOTE: Disassembly is Work-In-Progress.
; Label naming is loosely based on Action_ActionName_SubAction e.g. Print_HighScore_Loop.

> $4000 @org=$4000
b $4000 Loading Screen
D $4000 #UDGTABLE { =h Trashman Loading Screen } { #SCR$02(loading) } UDGTABLE#
@ $4000 label=Loading
  $4000,$1800,$20 Pixels
  $5800,$0300,$20 Attributes

i $5B00

b $5CF0

b $7080
@ $7080 label=ShadowBuffer_Pixels

b $70BF Shadow Buffer?

b $73D4 Shadow Buffer?
  $73D4,$20,$10

b $7840
@ $7840 label=ShadowBuffer_Attributes

b $785F Shadow Buffer?

b $78A0 Shadow Buffer?

b $95B0 Graphics: Game
  $95B0 #UDG(#PC)
L $95B0,$08,$1E

b $96A0 Graphics:
  $96A0,$20,$10 #UDGTABLE { #UDGARRAY$02,scale=$04,step=$02((#PC)-(#PC+$50)-$01-$10)(trashman-01) } UDGTABLE#

b $A200 Graphics: Additional
  $A200 #UDG(#PC)
L $A200,$08,$72

c $A590 Game Entry Point
@ $A590 label=GameEntryPoint
  $A590,$05 Write #N$00 to *#R$CC3D.
  $A595,$04 #REGi=#N$9F.
  $A599,$02 Set interrupt mode 2.
  $A59B,$01 Enable interrupts.
  $A59C,$02 #REGa=#REGr.
  $A59E,$02,b$01 Set bit 7.
  $A5A0,$03 Write #REGa to #R$C1E5.

@ $A5A3 label=Game_Loop
  $A5A3,$03 Call #R$A740.
  $A5A6,$03 Call #R$A77E.
  $A5A9,$03 Call #R$A675.
  $A5AC,$03 Call #R$A740.
  $A5AF,$03 Call #R$A77E.
  $A5B2,$03 Call #R$A97A.
  $A5B5,$03 Call #R$A6D5.
  $A5B8,$03 Call #R$A77E.

@ $A5BB label=NewLevel
  $A5BB,$03 Call #R$A944.
  $A5BE,$03 Call #R$A89B.
  $A5C1,$03 Call #R$A7F5.
  $A5C4,$03 Call #R$B0A1.
N $A5C7 The game has ended ... check why.
  $A5C7,$03 #REGa=*#R$B008.
  $A5CA,$04 Jump to #R$A61D if the bonus/ time counter reached zero.
  $A5CE,$03 #REGhl=#R$C272.
  $A5D1,$03 Call #R$CB22.
N $A5D4 Check other reasons why the game ended (see #POKE(immunity,)).
  $A5D4,$03 #REGa=*#R$B008.
  $A5D7,$05 Jump to #R$A667 if bit 0 is set.
  $A5DC,$03 #REGhl=*#R$AB7E.
N $A5DF Point to the current players level.
  $A5DF,$01 Increment #REGhl by one.
N $A5E0 Has the player completed the game?
  $A5E0,$05 Jump to #R$A5F7 if the current players level is #N$0C.
  $A5E5,$02 Increment *#REGhl by two.
  $A5E7,$03 Call #R$A99F.
  $A5EA,$03 Call #R$A7F5.
@ $A5ED label=SwitchPlayers
  $A5ED,$03 Call #R$A9D4.
  $A5F0,$02 Jump to #R$A5BB if 2UP is active.
  $A5F2,$03 Call #R$A9D4.
  $A5F5,$02 Jump to #R$A5BB.
N $A5F7 Who is in play, is it 1UP or 2UP?
@ $A5F7 label=Game_Complete
  $A5F7,$03 #REGhl=#R$AB8A.
  $A5FA,$04 Jump to #R$A602 if this is player two.
  $A5FE,$02 Reset bit 6 of *#REGhl.
  $A600,$02 Jump to #R$A604.
@ $A602 label=NewLevel_2UP_CopyScore
  $A602,$02 Reset bit 7 of *#REGhl.
@ $A604 label=NewLevel_CopyScore
  $A604,$03 Call #R$A9C5.
  $A607,$03 Call #R$AAA9.
  $A60A,$03 Call #R$AB12.
  $A60D,$03 Call #R$A7F5.
  $A610,$03 Call #R$AA69.
  $A613,$03 Call #R$A7F5.
  $A616,$03 Call #R$A9D4.
  $A619,$02 Jump to #R$A5BB if 2UP is active.
  $A61B,$02 Jump to #R$A5A3.

c $A61D Handler: Time Out
@ $A61D label=Handler_TimeOut
N $A61D Fetch the active player.
  $A61D,$03 #REGhl=*#R$AB7E.
N $A620 Action, decrease the active players lives by one.
N $A620 See #POKE(infinite_lives,).
  $A620,$01 Decrease *#REGhl by one.
N $A621 Is the player out of lives?
  $A621,$01 #REGa=*#REGhl.
N $A622 This is why #R$A97D can't be altered on its own to set higher staring lives.
  $A622,$02,b$01 Keep only bits 0-1.
  $A624,$02 Jump to #R$A62E if is zero.
  $A626,$03 Call #R$A9EF.
  $A629,$03 Call #R$A7F5.
  $A62C,$02 Jump to #R$A5ED.

c $A62E Handler: Fired
@ $A62E label=Handler_Fired
  $A62E,$03 Call #R$A9C5.
  $A631,$03 Call #R$AAA9.
  $A634,$03 Call #R$AA33.
  $A637,$03 Call #R$A7F5.
N $A63A Who is in play, is it 1UP or 2UP?
@ $A63A label=Handler_Fired_PlayerCheck
  $A63A,$03 #REGhl=#R$AB8A.
  $A63D,$04 Jump to #R$A645 if this is player two.
  $A641,$02 Reset bit 6 of *#REGhl.
  $A643,$02 Jump to #R$A647.
@ $A645 label=Handler_Fired_2UP
  $A645,$02 Reset bit 7 of *#REGhl.
@ $A647 label=Handler_Fired_HighScoreCheck
  $A647,$04 Jump to #R$A659 if the score is on the High Score table.
  $A64B,$03 Call #R$A9D4.
  $A64E,$03 Jump to #R$A5BB if there is still an active player.
  $A651,$03 Call #R$AA69.
  $A654,$03 Call #R$A7F5.
  $A657,$02 Jump to #R$A672.
@ $A659 label=Handler_Fired_HighScore
  $A659,$03 Call #R$AA69.
  $A65C,$03 Call #R$A7F5.
  $A65F,$03 Call #R$A9D4.
  $A662,$03 Jump to #R$A5BB if there is still an active player.
  $A665,$02 Jump to #R$A672.
N $A667 Trashman is killed in action.
@ $A667 label=GameOver_Dead
  $A667,$03 Call #R$A9C5.
  $A66A,$03 Call #R$AAA9.
  $A66D,$03 Call #R$A8D4.
  $A670,$02 Jump to #R$A63A.
N $A672 Just jump back into the game loop.
@ $A672 label=Alias_JumpGameLoop
  $A672,$03 Jump back to #R$A5A3.

c $A675 Game Selection Menu
@ $A675 label=GameMenu
N $A675 Prints "Please select method of control".
  $A675,$03 #REGhl=#R$AB8B.
  $A678,$03 #REGde=#N$4820 (screen buffer location).
  $A67B,$03 Call #R$B081.
N $A67E Prints "1 : Keyboard ( cursor keys )".
  $A67E,$03 #REGhl=#R$ABAB.
  $A681,$03 #REGde=#N$4861 (screen buffer location).
  $A684,$03 Call #R$B081.
N $A687 Prints "2 : Kempston joystick".
  $A687,$03 #REGhl=#R$ABC8.
  $A68A,$03 #REGde=#N$4881 (screen buffer location).
  $A68D,$03 Call #R$B081.
N $A690 Prints "3 : Interface 2".
  $A690,$03 #REGhl=#R$ABDE.
  $A693,$03 #REGde=#N$48A1 (screen buffer location).
  $A696,$03 Call #R$B081.
N $A699 Prints "4 : Cursor key type joysticks".
  $A699,$03 #REGhl=#R$ABEE.
  $A69C,$03 #REGde=#N$48C1 (screen buffer location).
  $A69F,$03 Call #R$B081.
N $A6A2 Handle retrieving the players input.
  $A6A2,$05 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$F7 | 1 | 2 | 3 | 4 | 5 }
. TABLE#
@ $A6A5 label=GameMenu_Loop
  $A6A7,$07 If "1" is pressed, set #REGhl to #R$B6BF and jump to #R$A6C0.
  $A6AE,$04 If "4" is pressed jump to #R$A6C0.
  $A6B2,$07 If "2" is pressed, set #REGhl to #R$B6E5 and jump to #R$A6C0.
  $A6B9,$07 If "3" is not pressed, set #REGhl to #R$B703 and jump to #R$A6A5.
N $A6C0 #HTML(The controller routine is written as the target address for a <code>CALL</code> operation at #R$B6BB.)
@ $A6C0 label=GameMenu_WriteControl
  $A6C0,$03 Write the appropriate controller location from #REGhl into the CALL target at *#R$B6BB(#N$B6BC).
  $A6C3,$03 Call #R$A7FB.
  $A6C6,$01 Return.

c $A6C7 Handler: Debounce Space
@ $A6C7 label=Handler_DebounceSpace
  $A6C7,$05 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$7F | SPACE | FULL-STOP | M | N | B }
. TABLE#
  $A6CC,$03 Return if "SPACE" is not being pressed.
  $A6CF,$03 Clear the call stack.
  $A6D2,$03 Jump to #R$A5A3.

c $A6D5 Get Players Name
@ $A6D5 label=Player_Name
  $A6D5,$03 #REGhl=#R$AC0C.
  $A6D8,$03 #REGde=#N$4828 (screen buffer location).
  $A6DB,$03 Call #R$B081.
  $A6DE,$03 #REGhl=#N$4848 (screen buffer location).
  $A6E1,$02 #REGb=#N$10.
  $A6E3,$03 Call #R$A895.
  $A6E6,$03 #REGhl=#R$AC8F.
  $A6E9,$03 #REGde=#N$48C0 (screen buffer location).
  $A6EC,$03 Call #R$B081.
  $A6EF,$05 Write #N$FF to #N$4FD7.
  $A6F4,$03 #REGhl=#R$AB8A.
  $A6F7,$02 Reset bit 4 of *#REGhl.
  $A6F9,$03 #REGhl=#R$ACA6.
  $A6FC,$03 Call #R$A78C.
  $A6FF,$03 Call #R$A7FB.
  $A702,$03 #REGhl=#R$ACD1.
  $A705,$03 #REGde=#N$48C0 (screen buffer location).
  $A708,$03 Call #R$B081.
  $A70B,$03 #REGa=*#R$AB8A.
  $A70E,$03 Call #R$A884.
  $A711,$03 Call #R$A859.
  $A714,$03 Call #R$A7FB.
  $A717,$03 #REGhl=#R$AB8A.
  $A71A,$02 Set bit 6 of *#REGhl.
  $A71C,$03 Return if bit 5 of *#REGhl is not set.
  $A71F,$02 Set bit 4 of *#REGhl.
  $A721,$03 #REGhl=#R$ACB0.
  $A724,$03 #REGde=#N$48C0 (screen buffer location).
  $A727,$03 Call #R$B081.
  $A72A,$05 Write #N$FF to #N$4FD7.
  $A72F,$03 #REGhl=#R$ACC7.
  $A732,$03 Call #R$A78C.
  $A735,$03 Call #R$A7FB.
  $A738,$03 #REGhl=#R$AB8A.
  $A73B,$02 Reset bit 4 of *#REGhl.
  $A73D,$02 Set bit 7 of *#REGhl.
  $A73F,$01 Return.

c $A740 Blank The Middle Of The Attribute Buffer
@ $A740 label=BlankMiddleAttributeBuffer
  $A740,$03 #REGhl=#N$5900.
  $A743,$03 #REGde=#N$5901.
  $A746,$03 #REGbc=#N($00FF,$04,$04).
  $A749,$02 Write #N$30 (#COLOUR$30) to *#REGhl.
  $A74B,$02 Copy #REGhl to #REGde #N($00FF,$04,$04) more times.
  $A74D,$04 Set the border to yellow.
  $A751,$01 Return.

c $A752 Prepare Attribute Buffer
@ $A752 label=PrepareAttributeBuffer
N $A752 Todo ...
  $A752,$03 #REGhl=#N$5900.
  $A755,$03 #REGde=#N$5901.
  $A758,$03 #REGbc=#N($00FF,$04,$04).
  $A75B,$02 Write #N$07 to *#REGhl.
  $A75D,$02 Copy #REGhl to #REGde #N($00FF,$04,$04) more times.
  $A75F,$04 Set the border to black.
  $A763,$02 #REGa=#N$00.
N $A765
  $A765,$03 #REGhl=#N$5800.
  $A768,$03 #REGde=#N$5801.
  $A76B,$03 #REGbc=#N($003F,$04,$04).
  $A76E,$01 Write #REGa to *#REGhl.
  $A76F,$02 Copy #REGhl to #REGde #N($003F,$04,$04) more times.
  $A771,$03 #REGhl=#N$5AC0.
  $A774,$03 #REGde=#N$5C01.
  $A777,$03 #REGbc=#N($003F,$04,$04).
  $A77A,$01 Write #REGa to *#REGhl.
  $A77B,$02 Copy #REGhl to #REGde #N($00FF,$04,$04) more times.
  $A77D,$01 Return.

c $A77E Blank The Middle Of The Screen
@ $A77E label=BlankMiddleScreenBuffer
N $A77E Writes #N$00 to the middle screen area.
  $A77E,$03 #REGhl=#N$4800.
  $A781,$03 #REGde=#N$4801.
  $A784,$03 #REGbc=#N$07FF.
  $A787,$02 Write #N$00 to *#REGhl.
  $A789,$02 Copy #REGhl to #REGde #N$07FF more times.
  $A78B,$01 Return.

c $A78C Controller: Name Selection
@ $A78C label=Controller_NameSelect
R $A78C HL Either #R$ACA6 or #R$ACC7.
  $A78C,$03 #REGa=*#R$AB8A.
  $A78F,$02,b$01 Keep only bits 4-7.
  $A791,$02,b$01 Set bit 3.
  $A793,$03 Write #REGa back to #R$AB8A.
@ $A796 label=Handler_NameSelect_Loop
  $A796,$05 Write #N$00 to #R$CC3D.
  $A79B,$01 Stash #REGhl on the stack.
  $A79C,$02 #REGb=#N$0A.
  $A79E,$03 Call #R$CB9C.
  $A7A1,$03 #REGhl=#R$CC3D.
  $A7A4,$02 Write #N$00 to *#REGhl.
  $A7A6,$02 Decrease counter by one and loop back to #R$A79E until counter is zero.
  $A7A8,$02 Write #N$01 to *#REGhl.
  $A7AA,$06 Write #N($0080,$04,$04) #REGhl to *#R$CC3B.
  $A7B0,$03 Call #R$A6C7.
  $A7B3,$01 Restore #REGhl from the stack.
  $A7B4,$03 Call #R$B6BB.
  $A7B7,$01 #REGa=#REGe.
N $A7B8 Was "up" pressed?
  $A7B8,$04 Jump to #R$A80C if #REGa is #N$18
N $A7BC Was "down" pressed?
  $A7BC,$04 Jump to #R$A818 if #REGa is #N$08.
N $A7C0 #HTML(Was "fire" <em>not</em> pressed?)
  $A7C0,$04 Jump to #R$A796 if #REGa is not #N$80.
  $A7C4,$01 Stash #REGhl on the stack.
  $A7C5,$06 Write #N($0040,$04,$04) to *#R$CC3B.
  $A7CB,$04 Decrease *#R$AB8A by one.
  $A7CF,$02 #REGa=#N$07.
  $A7D1,$01 Merge the bits from *#REGhl.
  $A7D2,$02 Jump to #R$A7DF if the result is zero.
  $A7D4,$03 Call #R$A83A.
  $A7D7,$03 Call #R$A7EB.
  $A7DA,$01 Restore #REGhl from the stack.
  $A7DB,$01 Increment #REGhl by one.
  $A7DC,$01 Halt operation (suspend CPU until the next interrupt).
  $A7DD,$02 Jump to #R$A79B.
  $A7DF,$01 Restore #REGhl from the stack.
  $A7E0,$01 Return.

c $A7E1 Handler: Press "Fire" To Continue
@ $A7E1 label=Handler_Press_Fire
  $A7E1,$01 Halt operation (suspend CPU until the next interrupt).
  $A7E2,$03 Fetch the controller response (into #REGe) by calling #R$B6BB.
  $A7E5,$05 If the "fire" key is not being pressed (#N$80 == "fire") jump to #R$A7E1.
  $A7EA,$01 Return.

c $A7EB Handler: Debounce Controls
@ $A7EB label=Handler_Debounce_Controls
  $A7EB,$01 Halt operation (suspend CPU until the next interrupt).
  $A7EC,$03 Fetch the controller response (into #REGe) by calling #R$B6BB.
  $A7EF,$05 Jump to #R$A7EB when the control reponse is #N$C0 (#N$C0 == "no action").
  $A7F4,$01 Return.

c $A7F5 Press Any Key
@ $A7F5 label=PressAnyKey
N $A7F5 #HTML(Not technically <em>any key</em> but any control button.)
  $A7F5,$03 Call #R$A7EB.
  $A7F8,$03 Call #R$A7E1.
  $A7FB,$03 #REGbc=#N($0040,$04,$04).
  $A7FE,$04 Write #REGbc to *#R$CC3B.
  $A802,$01 Halt operation (suspend CPU until the next interrupt).
  $A803,$05 Write #N$01 to *#R$CC3D.
  $A808,$03 Call #R$CB9C.
  $A80B,$01 Return.

c $A80C Handler: Player Name Selection
@ $A80C label=Handler_NameSelect_Up
R $A82E HL The address which contains the player name being created
N $A80C Action "user has pressed "up":
  $A80C,$01 #REGa=the current letter.
N $A80D Special handling for "space" as it's out of sequence with the other lettering.
  $A80D,$04 Jump to #R$A824 if #REGa is currently #N$20 (ASCII "space").
  $A811,$04 Jump to #R$A828 if #REGa is currently #N$5A (ASCII "Z").
N $A815 We're within the upper and lower boundaries, so move "up" a letter.
  $A815,$01 Increment #REGa by one.
  $A816,$02 Jump to #R$A82E.
N $A818 Action "user has pressed "down":
@ $A818 label=Handler_NameSelect_Down
  $A818,$01 #REGa=the current letter.
N $A819 Special handling for "space" as it's out of sequence with the other lettering.
  $A819,$04 Jump to #R$A82C if #REGa is currently #N$20 (ASCII "space").
  $A81D,$04 Jump to #R$A828 if #REGa is currently #N$41 (ASCII "A").
N $A821 We're within the upper and lower boundaries, so move "down" a letter.
  $A821,$01 Decrease #REGa by one.
  $A822,$02 Jump to #R$A82E.
N $A824 The upper boundrary has been reached, so cycle back to the letter "A".
@ $A824 label=NameSelect_BackTo_A
  $A824,$02,c$01 #REGa=#N$41 (ASCII "A").
  $A826,$02 Jump to #R$A82E.
@ $A828 label=NameSelect_Space
  $A828,$02,c$01 #REGa=#N$20 (ASCII "space").
  $A82A,$02 Jump to #R$A82E.
N $A82C The lower boundrary has been reached, so cycle back to the letter "Z".
@ $A82C label=NameSelect_BackTo_Z
  $A82C,$02,c$01 #REGa=#N$5A (ASCII "Z").
@ $A82E label=Handler_NameSelect_Write
  $A82E,$01 Write #REGa to *#REGhl.
  $A82F,$01 Stash #REGhl on the stack.
  $A830,$03 #REGhl=#R$AB8A.
  $A833,$03 Call #R$A83A.
  $A836,$01 Restore #REGhl from the stack.
  $A837,$03 Jump to #R$A79B.

c $A83A Display Player Name
N $A83A Who is in play, is it 1UP or 2UP?
  $A83A,$02 Test bit 4 of *#REGhl.
N $A83C Default to using the 1UP name.
  $A83C,$03 #REGhl=#R$ACA6.
  $A83F,$02 Jump to #R$A844 if this is player one.
N $A841 Else, use the name for 2UP.
  $A841,$03 #REGhl=#R$ACC7.
  $A844,$03 #REGde=#N$48D7 (screen buffer location).
  $A847,$03 Call #R$B081.
  $A84A,$03 #REGa=*#R$AB8A.
  $A84D,$02,b$01 Keep only bits 0-3.
  $A84F,$03 #REGhl=#N$4FDF (screen buffer location).
  $A852,$01 #REGa-=#REGl.
  $A853,$02 NEG.
  $A855,$01 #REGl=#REGa.
  $A856,$02 Write #N$FF to *#REGhl.
  $A858,$01 Return.

c $A859 Controller: Yes/ No
@ $A859 label=Controller_Yes_No
  $A859,$03 Call #R$A7EB.
N $A85C Produce a short pause.
@ $A85C label=Controller_Yes_No_Loop
  $A85C,$02 #REGb=#N$0A.
@ $A85E label=Controller_Yes_No_Pause
  $A85E,$01 Halt operation (suspend CPU until the next interrupt).
  $A85F,$02 Decrease counter by one and loop back to #R$A85E until counter is zero.
N $A861 Fetch player input.
  $A861,$03 Call #R$B6BB.
  $A864,$01 #REGa=#REGe.
N $A865 Was "up" pressed?
  $A865,$04 Jump to #R$A872 if #REGa is #N$18.
N $A869 Was "down" pressed?
  $A869,$04 Jump to #R$A872 if #REGa is #N$08.
N $A86D #HTML(Was "fire" <em>not</em> pressed?)
  $A86D,$04 Jump to #R$A85C if #REGa is not #N$80.
N $A871 Pressing "fire" exits/ sets the value.
  $A871,$01 Return.
N $A872 Flip bit 5 of #REGa (#N$20) using XOR with *#R$AB8A.
@ $A872 label=Controller_Yes_No_Action
  $A872,$03 #REGhl=#R$AB8A.
  $A875,$02,b$01 #REGa=#N$20.
  $A877,$01 Flip bit 5 of #REGa using XOR with *#REGhl.
  $A878,$01 Write #REGa to *#REGhl.
M $A872,$07 Flip bit 5 of #R$AB8A.
N $A879 Update the text on the screen to reflect the players choice.
  $A879,$03 Call #R$A884.
  $A87C,$03 #REGbc=#N($0080,$04,$04).
  $A87F,$03 Call #R$A7FE.
  $A882,$02 Jump to #R$A859.

c $A884 Handler: Print Yes/ No
@ $A884 label=Handler_Yes_No
  $A884,$02 Test bit 5 of #REGa.
N $A886 Default to using "NO".
  $A886,$03 #REGhl=#R$ACF2.
  $A889,$02 Jump to #R$A88E if bit 5 of #REGa is not set.
N $A88B Else, use "YES.
  $A88B,$03 #REGhl=#R$ACF6.
@ $A88E label=Handler_Yes_No_Write
  $A88E,$03 #REGde=#N$48DA (screen buffer location).
  $A891,$03 Call #R$B081.
  $A894,$01 Return.

c $A895 Concealer
@ $A895 label=Concealer
R $A895 B Number of locations to write #N$FF to
R $A895 HL Screen buffer address
  $A895,$02 Write #N$FF to *#REGhl.
  $A897,$01 Increment #REGhl by one.
  $A898,$02 Decrease counter by one and loop back to #R$A895 until counter is zero.
  $A89A,$01 Return.

c $A89B Handler: Street Introduction
@ $A89B label=Handler_StreetIntroduction
  $A89B,$03 Call #R$A77E.
N $A89E Print "Trashman ".
  $A89E,$03 #REGhl=#R$ACFA.
  $A8A1,$03 #REGde=#N$4840 (screen buffer location).
  $A8A4,$03 Call #R$B081.
N $A8A7 Who is in play, is it 1UP or 2UP?
  $A8A7,$03 #REGhl=#R$AB8A.
  $A8AA,$02 Test bit 4 of *#REGhl.
N $A8AC Default to using the 1UP name.
  $A8AC,$03 #REGhl=#R$ACA6.
  $A8AF,$02 Jump to #R$A8B4 if this is player one.
N $A8B1 Else, use the name for 2UP.
  $A8B1,$03 #REGhl=#R$ACC7.
@ $A8B4 label=StreetIntro_PrintName
  $A8B4,$03 Call #R$B081.
  $A8B7,$01 Decrease #REGde by one.
N $A8B8 Print " go and collect".
  $A8B8,$03 #REGhl=#R$AD04.
  $A8BB,$03 Call #R$B081.
N $A8BE Prints the number of bins to collect.
  $A8BE,$03 #REGhl=*#R$C270.
  $A8C1,$03 #REGde=#N$4880 (screen buffer location).
  $A8C4,$03 Call #R$B081.
N $A8C7 Print " bins from ".
  $A8C7,$03 #REGhl=#R$AD14.
  $A8CA,$03 Call #R$B081.
N $A8CD Print the current street name.
  $A8CD,$03 #REGhl=#R$C280.
  $A8D0,$03 Call #R$B081.
  $A8D3,$01 Return.

c $A8D4 Handler: News Flash
@ $A8D4 label=Handler_NewsFlash
  $A8D4,$03 Call #R$A77E.
  $A8D7,$03 Call #R$A752.
N $A8DA Print "NEWS FLASH".
  $A8DA,$03 #REGhl=#R$AD20.
  $A8DD,$03 #REGde=#N$482B (screen buffer location).
  $A8E0,$03 Call #R$B081.
  $A8E3,$03 #REGhl=#N$484B (screen buffer location).
  $A8E6,$02 #REGb=#N$0A.
  $A8E8,$03 Call #R$A895.
N $A8EB Print "Trashman killed in".
  $A8EB,$03 #REGhl=#R$AD2B.
  $A8EE,$03 #REGde=#N$4860 (screen buffer location).
  $A8F1,$03 Call #R$B081.
N $A8F4 Prints the current road name.
  $A8F4,$03 #REGhl=#R$C280.
  $A8F7,$03 Call #R$B081.
N $A8FA Print "Nominee for TRASHMAN of the YEAR" if the score is on the scoreboard.
  $A8FA,$03 #REGde=#N$4880 (screen buffer location).
  $A8FD,$03 #REGhl=#R$AD3F.
  $A900,$03 #REGa=*#R$AB8A.
  $A903,$05 Call #R$B081 if the score is on the scoreboard.
N $A908 Print "Fred Scrunge, (".
  $A908,$03 #REGhl=#R$AD60.
  $A90B,$03 Call #R$B081.
N $A90E Default to using the 1UP name.
  $A90E,$03 #REGhl=#R$ACA6.
N $A911 Who is in play, is it 1UP or 2UP?
  $A911,$03 #REGa=*#R$AB8A.
  $A914,$04 Jump to #R$A91B if this is player one.
N $A918 Else, use the name for 2UP.
  $A918,$03 #REGhl=#R$ACC7.
@ $A91B label=Handler_NewsFlash_Write
  $A91B,$03 Call #R$B081.
N $A91E Print "), leaves".
  $A91E,$03 #REGhl=#R$AD70.
  $A921,$01 Decrease #REGde by one.
  $A922,$03 Call #R$B081.
N $A925 Print "wife, 3 kids, and        pts.".
  $A925,$03 #REGhl=#R$AD7A.
  $A928,$03 Call #R$B081.
N $A92B Move #REGde to the correct screen position to print the points.
  $A92B,$01 Exchange the #REGde register with the shadow #REGhl register.
  $A92C,$03 #REGde=#N$FFF5.
  $A92F,$01 #REGhl+=#REGde.
  $A930,$01 Exchange the #REGde register with the shadow #REGhl register.
N $A931 Print the players points.
  $A931,$03 Call #R$CB19.
  $A934,$03 Call #R$A7F5.
  $A937,$03 Call #R$A740.
  $A93A,$02 #REGa=#N$30 (#COLOUR$30).
  $A93C,$03 Call #R$A765.
  $A93F,$04 Set border colour to YELLOW.
  $A943,$01 Return.

c $A944 Initialise Street
@ $A944 label=InitialiseStreet
  $A944,$03 #REGhl=*#R$AB7E.
  $A947,$01 Increment #REGhl by one.
N $A948 Fetch the active players level.
  $A948,$01 #REGa=*#REGhl.
N $A949 Point to the active players score.
  $A949,$01 Increment #REGhl by one.
N $A94A Copy the players score to the active players score memory location.
  $A94A,$03 #REGde=#R$CB96.
  $A94D,$03 #REGbc=#N($0003,$04,$04).
  $A950,$02 Copy #REGhl to #REGde #N($0003,$04,$04) times.
  $A952,$01 #REGe=current level.
  $A953,$03 #REGhl=#R$BA69(#N$BA6A).
  $A956,$02 Write #N$00 to *#REGhl.
  $A958,$04 Jump to #R$A95E if #REGa is lower than #N$0A.
  $A95C,$02 Write #N$08 to *#REGhl.
N $A95E Create an offset in #REGde for the current level.
@ $A95E label=InitialiseStreet_Max
  $A95E,$02 #REGd=#N$00.
  $A960,$04 #REGix=#R$B073.
  $A964,$02 #REGix+=#REGde.
N $A966 Fetch the pointer to the level data.
  $A966,$03 #REGl=*#REGix+#N$00.
  $A969,$03 #REGh=*#REGix+#N$01.
  $A96C,$03 #REGde=#R$C270.
  $A96F,$03 #REGbc=#N($0217,$04,$04).
  $A972,$02 Copy all the level data to the active game, starting from #R$C270.
  $A974,$05 Write #N$00 to #R$B008.
  $A979,$01 Return.

c $A97A Initialise New Game
@ $A97A label=InitialiseNewGame
  $A97A,$03 #REGhl=#R$AB80.
N $A97D Set starting lives.
  $A97D,$02 Write #N$03 to *#REGhl.
  $A97F,$01 Increment #REGhl by one.
N $A980 Set starting level.
  $A980,$02 Write #N$00 to *#REGhl.
  $A982,$01 Increment #REGhl by one.
N $A983 Set starting score to #N($0000,$04,$04).
  $A983,$02 Write #N$00 to *#REGhl.
  $A985,$01 Increment #REGhl by one.
  $A986,$02 Write #N$00 to *#REGhl.
  $A988,$01 Increment #REGhl by one.
  $A989,$02 Write #N$00 to *#REGhl.
  $A98B,$01 Increment #REGhl by one.
N $A98C Remember where we are for the copy routine ahead.
  $A98C,$01 #REGe=#REGl.
  $A98D,$01 #REGd=#REGh.
N $A98E Set the active player to be 1UP.
  $A98E,$06 Write #R$AB80 to #R$AB7E.
  $A994,$03 #REGbc=#N($0005,$04,$04).
  $A997,$02 Copy the same values to 2UP.
N $A999 Reset the game flags for the new game.
  $A999,$05 Write #N$00 to #R$AB8A.
  $A99E,$01 Return.

c $A99F Finished Street
@ $A99F label=FinishedStreet
  $A99F,$03 Call #R$A77E.
  $A9A2,$03 Call #R$A740.
N $A9A5 Print "Good days work  there, Trashman".
  $A9A5,$03 #REGhl=#R$AD98.
  $A9A8,$03 #REGde=#N$4840 (screen buffer location).
  $A9AB,$03 Call #R$B081.
  $A9AE,$03 #REGhl=#R$AB8A.
N $A9B1 Who is in play, is it 1UP or 2UP?
  $A9B1,$02 Test bit 4 of *#REGhl.
N $A9B3 Default to using the 1UP name.
  $A9B3,$03 #REGhl=#R$ACA6.
  $A9B6,$02 Jump to #R$A9BB if this is player one.
N $A9B8 Else, use the name for 2UP.
  $A9B8,$03 #REGhl=#R$ACC7.
@ $A9BB label=FinishedStreet_Print
  $A9BB,$03 Call #R$B081.
N $A9BE Overwrite the ")" from the players name string.
  $A9BE,$01 Decrease #REGde by one.
N $A9BF Print the "Tomorrow we've another street for you." messaging.
  $A9BF,$03 #REGhl=#R$ADB9.
  $A9C2,$03 Call #R$B081.
@ $A9C5 label=CopyScore_ActiveScore
  $A9C5,$04 #REGde=*#R$AB7E.
  $A9C9,$02 Move to where the scores are held: #LIST { #R$AB82 } { #R$AB87 } LIST#
  $A9CB,$03 #REGhl=#R$CB96.
N $A9CE Scores are held using three bytes.
  $A9CE,$03 #REGbc=#N($0003,$04,$04).
  $A9D1,$02 Copy the three score digits for the current player into the active players score location.
  $A9D3,$01 Return.

c $A9D4 Switch Players
@ $A9D4 label=Handler_SwitchPlayers
  $A9D4,$03 #REGa=*#R$AB8A.
  $A9D7,$02,b$01 Flip bit 4.
  $A9D9,$03 Write #REGa to *#R$AB8A.
N $A9DC Default to using 1UP.
  $A9DC,$03 #REGhl=#R$AB80.
N $A9DF Who is in play, is it 1UP or 2UP?
  $A9DF,$04 Jump to #R$A9E6 if this is player one.
N $A9E3 Else, use 2UP.
  $A9E3,$03 #REGhl=#R$AB85.
@ $A9E6 label=Handler_SwitchPlayers_Write
  $A9E6,$03 Write #REGhl to *#R$AB7E.
  $A9E9,$01 Rotate #REGa left (with carry).
  $A9EA,$03 Return if bit 5 of #REGa is set.
  $A9ED,$01 Rotate #REGa left (with carry).
  $A9EE,$01 Return.

c $A9EF Print The "You're Fired" Screen
@ $A9EF label=Print_YoureFired
  $A9EF,$03 Call #R$A77E.
  $A9F2,$03 Call #R$A740.
N $A9F5 Print "Trashman ".
  $A9F5,$03 #REGhl=#R$ACFA.
  $A9F8,$03 #REGde=#N$4840 (screen buffer location).
  $A9FB,$03 Call #R$B081.
N $A9FE Who is in play, is it 1UP or 2UP?
  $A9FE,$05 Test bit 4 of #R$AB8A.
N $AA03 Default to using the 1UP name.
  $AA03,$03 #REGhl=#R$ACA6.
  $AA06,$02 Jump to #R$AA0B if this is player one.
N $AA08 Else, use the name for 2UP.
  $AA08,$03 #REGhl=#R$ACC7.
@ $AA0B label=Print_YoureFired_Write
  $AA0B,$03 Call #R$B081.
N $AA0E Overwrite the ")" from the players name string.
  $AA0E,$01 Decrease #REGde by one.
N $AA0F Print ", you're  slow." messaging.
  $AA0F,$03 #REGhl=#R$AE33.
  $AA12,$03 Call #R$B081.
N $AA15 Print the road name.
  $AA15,$03 #REGhl=#R$C280.
  $AA18,$03 Call #R$B081.
  $AA1B,$03 #REGhl=*#R$AB7E.
N $AA1E This assumes the default number of lives is being used, and displays a string for the number of times Trashman has been fired.
N $AA1E As this only tests bit 0, any poke like #POKE(infinite_lives,) will make this behave oddly.
  $AA1E,$02 Test bit 0 of *#REGhl.
  $AA20,$03 #REGhl=#R$B009.
  $AA23,$02 Jump to #R$AA28 if this isn't the last life.
  $AA25,$03 #REGhl=#R$B013.
@ $AA28 label=Print_YoureFired_WriteTimes
  $AA28,$03 Call #R$B081.
N $AA2B Print " more and you're fired.".
  $AA2B,$03 #REGhl=#R$AE71.
  $AA2E,$03 Call #R$B081.
  $AA31,$01 Return.
  $AA32,$01 Return.

c $AA33 You're Fired
@ $AA33 label=FiredScreen
  $AA33,$03 Call #R$A77E.
  $AA36,$03 Call #R$A740.
N $AA39 Print "YOU'RE FIRED!".
  $AA39,$03 #REGhl=#R$AE89.
  $AA3C,$03 #REGde=#N$482A (screen buffer location).
  $AA3F,$03 Call #R$B081.
  $AA42,$03 #REGhl=#N$484A (screen buffer location).
  $AA45,$02 #REGb=#N$0C.
  $AA47,$03 Call #R$A895.
N $AA4A Print " GO!  Take your ".
  $AA4A,$03 #REGhl=#R$AEEC.
  $AA4D,$03 #REGde=#N$4860 (screen buffer location).
  $AA50,$03 Call #R$B081.
N $AA53 Print the active players score.
  $AA53,$03 Call #R$AB73.
N $AA56 Print " Pts  withyou.  ".
  $AA56,$03 #REGhl=#R$AEFD.
  $AA59,$03 Call #R$B081.
  $AA5C,$03 #REGhl=#R$AB8A.
  $AA5F,$03 Return if the score isn't on the score board.
N $AA62 Print "you have been  nominated for TRASHMAN OF THE YEAR" messaging.
  $AA62,$03 #REGhl=#R$AE97.
  $AA65,$03 Call #R$B081.
  $AA68,$01 Return.

c $AA69 Print High Score Table
@ $AA69 label=Print_HighScoreTable
  $AA69,$03 Call #R$A77E.
  $AA6C,$03 Call #R$A740.
N $AA6F Print "TRASHMAN OF THE YEAR NOMINATIONS".
  $AA6F,$03 #REGde=#N$4820 (screen buffer location).
  $AA72,$03 #REGhl=#R$AE07.
  $AA75,$03 Call #R$B081.
  $AA78,$03 #REGhl=#N$4840 (screen buffer location).
  $AA7B,$02 #REGb=#N$20.
  $AA7D,$03 Call #R$A895.
  $AA80,$03 #REGde=#N$4865 (screen buffer location).
  $AA83,$03 #REGhl=#R$B043.
N $AA86 The game holds four high scores.
  $AA86,$02 #REGb=#N$04 (counter).
@ $AA88 label=Print_HighScoreTable_Loop
  $AA88,$01 Stash the counter held in #REGbc on the stack.
N $AA89 Print the players name for this position.
  $AA89,$03 Call #R$B081.
N $AA8C Score are held backwards, so add three to point to the last digit.
  $AA8C,$03 #REGbc=#N($0003,$04,$04).
  $AA8F,$01 #REGhl+=#REGbc.
N $AA90 Store the pointer for easily moving onto the next entry.
  $AA90,$01 Stash #REGhl on the stack.
  $AA91,$01 Exchange the #REGde register with the shadow #REGhl register.
  $AA92,$01 #REGhl+=#REGbc.
  $AA93,$01 Exchange the #REGde register with the shadow #REGhl register.
N $AA94 Scores are held using three bytes.
  $AA94,$02 #REGb=#N$03 (counter).
  $AA96,$03 Call #R$CAB3.
N $AA99 Print the "pts" suffix.
  $AA99,$03 #REGhl=#R$AE28.
  $AA9C,$03 Call #R$B081.
N $AA9F Update the screen buffer address for the next entry.
  $AA9F,$04 #REGe+=#N$0A.
N $AAA3 Restore the stashed pointer, and move onto the next entry.
  $AAA3,$01 Restore #REGhl from the stack.
  $AAA4,$01 Increment #REGhl by one.
N $AAA5 Fetch the counter, and loop until all the positions have been displayed.
  $AAA5,$01 Restore the counter to #REGbc from the stack.
  $AAA6,$02 Decrease counter by one and loop back to #R$AA88 until counter is zero.
  $AAA8,$01 Return.

c $AAA9 New High Score
@ $AAA9 label=NewHighScore
  $AAA9,$04 #REGix=#R$B043.
N $AAAD The game stores four high scores.
  $AAAD,$02 #REGb=#N$04.
@ $AAAF label=NewHighScore_CheckLoop
  $AAAF,$03 #REGhl=*#R$AB7E.
N $AAB2 Move to the last digit of the active score (the hundreds of thousands).
  $AAB2,$04 #REGhl+=#N($0004,$04,$04).
  $AAB6,$01 #REGa=*#REGhl.
  $AAB7,$05 Jump to #R$AAC9 if #REGa is higher than *#REGix+#N$0B.
  $AABC,$03 #REGde=#N($000C,$04,$04).
  $AABF,$02 #REGix+=#REGde.
  $AAC1,$02 Decrease counter by one and loop back to #R$AAAF until counter is zero.
  $AAC3,$03 #REGhl=#R$AB8A.
  $AAC6,$02 Reset bit 0 of *#REGhl.
  $AAC8,$01 Return.
  $AAC9,$02 Jump to #R$AADD if {} is not zero.
  $AACB,$01 Decrease #REGhl by one.
  $AACC,$01 #REGa=*#REGhl.
  $AACD,$05 Jump to #R$AABC if #REGa is lower than *#REGix+#N$0A.
  $AAD2,$02 Jump to #R$AADD if it is not zero.
  $AAD4,$01 Decrease #REGhl by one.
  $AAD5,$01 #REGa=*#REGhl.
  $AAD6,$05 Jump to #R$AABC if #REGa is lower than *#REGix+#N$09.
  $AADB,$02 Jump to #R$AABC if it is zero.
  $AADD,$01 Decrease #REGb by one.
  $AADE,$02 Jump to #R$AAEF if #REGb is zero.
  $AAE0,$02 #REGa=#N$00.
  $AAE2,$02 #REGa+=#N$0C.
  $AAE4,$02 Decrease counter by one and loop back to #R$AAE2 until counter is zero.
  $AAE6,$01 #REGc=#REGa.
  $AAE7,$03 #REGhl=#R$B066.
  $AAEA,$03 #REGde=#R$B072.
  $AAED,$02 LDDR.
@ $AAEF label=NewHighScore_Write
  $AAEF,$03 #REGde=#REGix.
  $AAF2,$03 #REGhl=#R$AB8A.
  $AAF5,$02 Set bit 0 of *#REGhl.
N $AAF7 Who is in play, is it 1UP or 2UP?
  $AAF7,$02 Test bit 4 of *#REGhl.
N $AAF9 Default to using the 1UP name.
  $AAF9,$03 #REGhl=#R$ACA6.
  $AAFC,$02 Jump to #R$AB01 if this is player one.
N $AAFE Else, use the name for 2UP.
  $AAFE,$03 #REGhl=#R$ACC7.
@ $AB01 label=NewHighScore_WriteName
  $AB01,$03 #REGbc=#N($0008,$04,$04).
  $AB04,$02 Copy the exact number of bytes of the players name to the high score entry.
  $AB06,$01 Increment #REGde by one.
  $AB07,$03 #REGhl=*#R$AB7E.
  $AB0A,$02 Increment #REGhl by two.
N $AB0C Scores are held using three bytes.
  $AB0C,$03 #REGbc=#N($0003,$04,$04).
  $AB0F,$02 Copy the three score digits for the current player into the high score entry.
  $AB11,$01 Return.

c $AB12 Messaging: Game Over
@ $AB12 label=Messaging_GameOver
  $AB12,$03 Call #R$A740.
  $AB15,$03 Call #R$A77E.
N $AB18 Print "ACADEMY OF TRASHMEN DIPLOMA".
  $AB18,$03 #REGhl=#R$AF0E.
  $AB1B,$03 #REGde=#N$4822 (screen buffer location).
  $AB1E,$03 Call #R$B081.

  $AB21,$03 #REGhl=#N$4842 (screen buffer location).
  $AB24,$02 #REGb=#N$1B.
  $AB26,$03 Call #R$A895.
N $AB29 Print "This is to certify that ".
  $AB29,$03 #REGhl=#R$AF2A.
  $AB2C,$03 #REGde=#N$4860 (screen buffer location).
  $AB2F,$03 Call #R$B081.
N $AB32 Who is in play, is it 1UP or 2UP?
  $AB32,$03 #REGhl=#R$AB8A.
  $AB35,$02 Test bit 4 of *#REGhl.
N $AB37 Default to using the 1UP name.
  $AB37,$03 #REGhl=#R$ACA6.
  $AB3A,$02 Jump to #R$AB3F if this is player one.
N $AB3C Else, use the name for 2UP.
  $AB3C,$03 #REGhl=#R$ACC7.
@ $AB3F label=Messaging_GameOver_PrintName
  $AB3F,$03 Call #R$B081.
N $AB42 Print "has    completed  a  course   in TRASHMANSHIP , and may  go forth to rid the world of trash.".
  $AB42,$03 #REGde=#N$4880 (screen buffer location).
  $AB45,$03 #REGhl=#R$AF43.
  $AB48,$03 Call #R$B081.
  $AB4B,$03 Call #R$A7F5.
  $AB4E,$03 Call #R$A77E.
N $AB51 Print "Your score was ".
  $AB51,$03 #REGhl=#R$AF9E.
  $AB54,$03 #REGde=#N$4842 (screen buffer location).
  $AB57,$03 Call #R$B081.
  $AB5A,$03 Call #R$AB73.
N $AB5D Print " pts.".
  $AB5D,$03 #REGhl=#R$AE28.
  $AB60,$03 Call #R$B081.
  $AB63,$03 #REGhl=#R$AB8A.
  $AB66,$03 Return if the score is not on the score board.
N $AB69 Print "Your  success  has  given you  a well earned  nomination  for the    TRASHMAN OF THE YEAR.".
  $AB69,$03 #REGhl=#R$AFAE.
  $AB6C,$03 #REGde=#N$4880 (screen buffer location).
  $AB6F,$03 Call #R$B081.
  $AB72,$01 Return.
N $AB73 Print the active players score.
@ $AB73 label=Messaging_GameOver_Score
  $AB73,$03 #REGhl=#R$CB96.
N $AB76 Move to the last digit of the score (prep for printing).
  $AB76,$02 Increment #REGhl by two.
  $AB78,$02 #REGb=#N$03 (the score is held by three bytes).
  $AB7A,$03 Call #R$CAB3.
  $AB7D,$01 Return.

g $AB7E Pointer To Active Player
@ $AB7E label=ActivePlayer
W $AB7E,$02
@ $AB80 label=1UP_Lives
@ $AB81 label=1UP_Level
@ $AB82 label=1UP_Score
@ $AB85 label=2UP_Lives
@ $AB86 label=2UP_Level
@ $AB87 label=2UP_Score
B $AB80,$01
B $AB81,$01
B $AB82,$03
L $AB80,$05,$02

g $AB8A Game Flags
@ $AB8A label=Game_Flags
D $AB8A #TABLE(default,centre,centre,centre,centre)
. { =h,c4 Bits }
. { =h 0 | =h 1 | =h 2 | =h 3 }
. { On High Score table | To-do | To-do | To-do }
. { =h 4 | =h 5 | =h 6 | =h 7 }
. { Active player | 1UP or 2UP | 1UP In-Play | 2UP In-Play }
. TABLE#
B $AB8A,$01

t $AB8B Messaging: Selection Screen
D $AB8B Each string uses #N$80 as a terminator (bit 7 is set).
@ $AB8B label=Messaging_SelectControl
  $AB8B,$20,$1F:$01 #FONT$E417,attr=$30,chars=0(Please select method of control)(select-01)
@ $ABAB label=Messaging_SelectKeyboard
  $ABAB,$1D,$1C:$01 #FONT$E417,attr=$30,chars=0(1 : Keyboard ( cursor keys ))(select-02)
@ $ABC8 label=Messaging_SelectKempston
  $ABC8,$16,$15:$01 #FONT$E417,attr=$30,chars=0(2 : Kempston joystick)(select-03)
@ $ABDE label=Messaging_SelectInterface2
  $ABDE,$10,$0F:$01 #FONT$E417,attr=$30,chars=0(3 : Interface 2)(select-04)
@ $ABEE label=Messaging_SelectCursor
  $ABEE,$1E,$1D:$01 #FONT$E417,attr=$30,chars=0(4 : Cursor key type joysticks)(select-05)

t $AC0C Messaging: Situation Vacant
@ $AC0C label=Messaging_SituationVacant
  $AC0C,$83,$10,$14,$14,$20,$20,$0B,$0A:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(SITUATION VACANT)(situation-vacant-1) }
. { #FONT$E417,attr=$30,chars=0(                    )(situation-vacant-2) }
. { #FONT$E417,attr=$30,chars=0(                    )(situation-vacant-2) }
. { #FONT$E417,attr=$30,chars=0(Trashman required: must be alert)(situation-vacant-3) }
. { #FONT$E417,attr=$30,chars=0(nimble footed, and able to  hold)(situation-vacant-4) }
. { #FONT$E417,attr=$30,chars=0(his drink.)(situation-vacant-5) }
. TABLE#

t $AC8F Messaging: Enter Applicants Name (1UP)
@ $AC8F label=Messaging_EnterName1UP
  $AC8F,$21,$17,$08,$01:$01 #FONT$E417,attr=$30,chars=0(Enter applicants name (        ))(applicant-name)
@ $ACA6 label=Name_1UP
@ $ACB0 label=Messaging_EnterName2UP
  $ACB0,$21,$17,$08,$01:$01 #FONT$E417,attr=$30,chars=0(Enter applicants name (        ))(applicant-name)
@ $ACC7 label=Name_2UP
@ $ACD1 label=Messaging_AnyMoreApplicants
  $ACD1,$21,$20:$01 #FONT$E417,attr=$30,chars=0(Any more applicants             )(more-applicants)
@ $ACF2 label=Messaging_No
  $ACF2,$04,$03:$01 #FONT$E417,attr=$30,chars=0(NO )(no)
@ $ACF6 label=Messaging_Yes
  $ACF6,$04,$03:$01 #FONT$E417,attr=$30,chars=0(YES)(yes)

t $ACFA Messaging: Street Introduction
@ $ACFA label=Messaging_Trashman
  $ACFA,$0A,$09:$01 #FONT$E417,attr=$30,chars=0(Trashman )(trashman)
@ $AD04 label=Messaging_GoCollect
  $AD04,$10,$0F:$01 #FONT$E417,attr=$30,chars=0( go and collect)(go-collect)
@ $AD14 label=Messaging_BinsFrom
  $AD14,$0C,$0B:$01 #FONT$E417,attr=$30,chars=0( bins from )(bins-from)

t $AD20 Messaging: News Flash
@ $AD20 label=Messaging_NewsFlash_1
  $AD20,$0B,$0A:$01 #FONT$E417,attr=$30,chars=0(NEWS FLASH)(news-flash)
@ $AD2B label=Messaging_NewsFlash_2
  $AD2B,$14,$13:$01 #FONT$E417,attr=$30,chars=0(Trashman killed in )(trashman-killed)
@ $AD3F label=Messaging_NewsFlash_3
  $AD3F,$21,$20:$01 #FONT$E417,attr=$30,chars=0(Nominee for TRASHMAN of the YEAR)(nominee)
@ $AD60 label=Messaging_NewsFlash_4
  $AD60,$10,$0F:$01 #FONT$E417,attr=$30,chars=0(Fred Scrunge, )(fred-scrunge)
@ $AD70 label=Messaging_NewsFlash_5
  $AD70,$0A,$09:$01 #FONT$E417,attr=$30,chars=0(, leaves)(leaves)
@ $AD7A label=Messaging_NewsFlash_6
  $AD7A,$1E,$1D:$01 #FONT$E417,attr=$30,chars=0(wife, 3 kids, and        pts.")(wife)

t $AD98 Messaging: Finished Street
@ $AD98 label=Messaging_FinishedStreet_1
  $AD98,$21,$20:$01 #FONT$E417,attr=$30,chars=0( Good days work  there, Trashman)(good-days)
@ $ADB9 label=Messaging_FinishedStreet_2
  $ADB9,$4E,$18,$20,$16:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(. Tomorrow we've another)(another-street-1) }
. { #FONT$E417,attr=$30,chars=0(street for you.  Let's  see  how)(another-street-2) }
. { #FONT$E417,attr=$30,chars=0(you fair on that one.)(another-street-3) }
. TABLE#

t $AE07 Messaging: Trashman Of The Year Nominations
@ $AE07 label=Messaging_Nominations
  $AE07,$21,$20:$01 #FONT$E417,attr=$30,chars=0(TRASHMAN OF THE YEAR NOMINATIONS)(nominations)
@ $AE28 label=Messaging_Pts
  $AE28,$06,$05:$01 #FONT$E417,attr=$30,chars=0( pts.)(pts)
  $AE2E,$05,$04:$01 #FONT$E417,attr=$30,chars=0(    )(four-spaces)

t $AE33 Messaging: Fired
@ $AE33 label=Messaging_Fired_1
  $AE33,$3E,$0F,$20,$0E:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(, you're  slow.)(complaints-1) }
. { #FONT$E417,attr=$30,chars=0(We've had complaints  about your)(complaints-2) }
. { #FONT$E417,attr=$30,chars=0(activities in )(complaints-3) }
. TABLE#
@ $AE71 label=Messaging_Fired_2
  $AE71,$18,$17:$01 #FONT$E417,attr=$30,chars=0( more and you're fired.)(more)

t $AE89 Messaging: YOU'RE FIRED!
@ $AE89 label=Messaging_Fired
  $AE89,$0E,$0D:$01 #FONT$E417,attr=$30,chars=0(YOU'RE FIRED!)(fired)

t $AE97 Messaging: Trashman Of The Year
@ $AE97 label=Messaging_TrashmanOfTheYear
  $AE97,$55,$1A,$20,$1A:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0( for  some  unaccountable)(trashman-of-the-year-1) }
. { #FONT$E417,attr=$30,chars=0(reason, you have been  nominated)(trashman-of-the-year-2) }
. { #FONT$E417,attr=$30,chars=0(for TRASHMAN OF THE YEAR )(trashman-of-the-year-3) }
. TABLE#

t $AEEC Messaging: Go! Take Your Pts With You
@ $AEEC label=Messaging_Go
  $AEEC,$11,$10:$01 #FONT$E417,attr=$30,chars=0( GO!  Take your )(go-1)
@ $AEFD label=Messaging_PtsWithYou
  $AEFD,$11,$10:$01 #FONT$E417,attr=$30,chars=0( Pts  withyou.  )(go-2)

t $AF0E Messaging: Academy Of Trashmen Diploma
@ $AF0E label=Messaging_TrashmenDiploma
  $AF0E,$1C,$1B:$01 #FONT$E417,attr=$30,chars=0(ACADEMY OF TRASHMEN DIPLOMA)(diploma)

t $AF2A Messaging: This Is To Certify
@ $AF2A label=Messaging_Certify_1
  $AF2A,$19,$18:$01 #FONT$E417,attr=$30,chars=0(This is to certify that )(certify-line-1)
@ $AF43 label=Messaging_Certify_2
  $AF43,$20 #FONT$E417,attr=$30,chars=0(has    completed  a  course   in)(certify-line-2)
  $AF63,$20 #FONT$E417,attr=$30,chars=0(TRASHMANSHIP , and may  go forth)(certify-line-3)
  $AF83,$1B,$1A:$01 #FONT$E417,attr=$30,chars=0(to rid the world of trash.)(certify-line-4)
@ $AF9E label=Messaging_Certify_3
  $AF9E,$10,$0F:$01 #FONT$E417,attr=$30,chars=0(Your score was )(certify-line-5)
@ $AFAE label=Messaging_Certify_4
  $AFAE,$20 #FONT$E417,attr=$30,chars=0(Your  success  has  given you  a)(certify-line-6)
  $AFCE,$20 #FONT$E417,attr=$30,chars=0(well earned  nomination  for the)(certify-line-7)
  $AFEE,$1A,$19:$01 #FONT$E417,attr=$30,chars=0(    TRASHMAN OF THE YEAR.)(certify-line-8)

g $B008 Flag: Game Over
@ $B008 label=Flag_GameOver
D $B008 A flag to indicate if the game is still in-play, or what the reason for
. death is.
. #TABLE(default,centre,centre)
. { =h Value | =h Meaning }
. { #N$00 | Not "Game Over" }
. TABLE#
B $B008,$01

t $B009 Messaging: Once
@ $B009 label=Messaging_Once
  $B009,$0A,$09:$01 #FONT$E417,attr=$30,chars=0(.    Once)(once)

t $B013 Messaging: Twice
@ $B013 label=Messaging_Twice
  $B013,$0B,$0A:$01 #FONT$E417,attr=$30,chars=0(.    Twice)(twice)

t $B01E Messaging: Number Of Bins To Collect
@ $B01E label=Messaging_Five
  $B01E,$05,$04:$01 #FONT$E417,attr=$30,chars=0(five)(five)
@ $B023 label=Messaging_Six
  $B023,$04,$03:$01 #FONT$E417,attr=$30,chars=0(six)(six)
@ $B027 label=Messaging_Seven
  $B027,$06,$05:$01 #FONT$E417,attr=$30,chars=0(seven)(seven)
@ $B02D label=Messaging_Eight
  $B02D,$06,$05:$01 #FONT$E417,attr=$30,chars=0(eight)(eight)
@ $B033 label=Messaging_Nine
  $B033,$05,$04:$01 #FONT$E417,attr=$30,chars=0(nine)(nine)
@ $B038 label=Messaging_Ten
  $B038,$04,$03:$01 #FONT$E417,attr=$30,chars=0(ten)(ten)
@ $B03C label=Messaging_Twelve
  $B03C,$07,$06:$01 #FONT$E417,attr=$30,chars=0(twelve)(twelve)

g $B043 High Score Table
@ $B043 label=Table_HighScore
T $B043,$09,$08:$01 Name.
  $B04C,$03,$01 Score.
L $B043,$0C,$04

w $B073 Table: Levels
@ $B073 label=Table_Levels
D $B073 Points to the data for each level.
  $B073,$02 Level #EVAL($01 + (#PC - $B073) / $02): #R(#PEEK(#PC) + #PEEK(#PC + $01) * $100).
L $B073,$02,$07

c $B081 Print String
@ $B081 label=PrintString
  $B081,$01 #REGa=*#REGhl.
@ $B082 label=PrintString_Loop
  $B082,$02 Stash #REGde and #REGhl on the stack.
N $B084 Create an offset in #REGhl.
  $B084,$01 #REGl=#REGa.
  $B085,$02 #REGh=#N$00.
  $B087,$03 #REGhl*=#N$08.
  $B08A,$03 #REGbc=#R$E417.
  $B08D,$01 Decrease #REGb by one.
  $B08E,$01 #REGhl+=#REGbc.
  $B08F,$02 #REGb=#N$08.
@ $B091 label=PrintString_Copy
  $B091,$01 #REGa=*#REGhl.
  $B092,$01 Write #REGa to *#REGde.
  $B093,$01 Increment #REGhl by one.
  $B094,$01 Increment #REGd by one.
  $B095,$02 Decrease counter by one and loop back to #R$B091 until counter is zero.
  $B097,$02 Restore #REGhl and #REGde from the stack.
  $B099,$01 Increment #REGde by one.
  $B09A,$01 Increment #REGhl by one.
  $B09B,$01 #REGa=*#REGhl.
  $B09C,$03 Return if bit 7 is set (the terminator).
  $B09F,$02 Jump to #R$B082.

c $B0A1 Start Game
@ $B0A1 label=StartGame
N $B0A1 Write #R$C375 to *#R$C277.
  $B0A1,$03 #REGhl=#R$C38D.
  $B0A4,$03 #REGde=#N$FFE8.
  $B0A7,$01 #REGhl+=#REGde.
  $B0A8,$03 Write #REGhl to *#R$C277.
  $B0AB,$03 Call #R$B0EA.
  $B0AE,$03 Call #R$BB36.
  $B0B1,$04 #REGix=#R$C36E.
  $B0B5,$03 #REGb=*#REGix+#N$13.
  $B0B8,$03 Call #R$B591.
@ $B0BB label=GameLoop
  $B0BB,$03 Call #R$CB9C.
  $B0BE,$03 Call #R$B44A.
  $B0C1,$03 Call #R$BCB7.
  $B0C4,$03 Call #R$B416.
  $B0C7,$03 Call #R$B3F0.
  $B0CA,$03 Call #R$CB0A.
  $B0CD,$03 Call #R$BF50.
  $B0D0,$03 Call #R$B724.
  $B0D3,$03 Call #R$BFEC.
  $B0D6,$03 Call #R$BD48.
  $B0D9,$03 Call #R$BD0D.
  $B0DC,$03 Call #R$BADD.
  $B0DF,$03 Call #R$BD89.
  $B0E2,$03 Call #R$BB73.
  $B0E5,$03 Call #R$B12B.
  $B0E8,$02 Jump to #R$B0BB.

c $B0EA Create Play Window
@ $B0EA label=Play_Window
N $B0EA #PUSHS #UDGTABLE {
.   #SIM(start=$A5AC,stop=$A5B5)#SIM(start=$A5B8,stop=$A5BE)
.   #SIM(start=$B0EA,stop=$B122)#SCR$02(play-window)
. } TABLE# #POPS
  $B0EA,$0D Write #N$00 to #N$1800 bytes starting from #N$4000.
N $B0F7 Paint the top two lines #COLOUR$30.
  $B0F7,$03 #REGhl=#N$5800.
  $B0FA,$03 Call #R$B123.
N $B0FD Paint the bottom two lines #COLOUR$30.
  $B0FD,$03 #REGhl=#N$5AC0.
  $B100,$03 Call #R$B123.
  $B103,$04 Set the border to YELLOW.
N $B107 Print "Score".
  $B107,$03 #REGde=#N$4001 (screen buffer location).
  $B10A,$03 #REGhl=#R$C1F5.
  $B10D,$03 Call #R$B081.
N $B110 Print "Bonus".
  $B110,$03 #REGde=#N$401A (screen buffer location).
  $B113,$03 #REGhl=#R$C1EF.
  $B116,$03 Call #R$B081.
N $B119 Prints the road name.
  $B119,$03 #REGde=#N$4009 (screen buffer location).
  $B11C,$03 #REGhl=#R$C280.
  $B11F,$03 Call #R$B081.
  $B122,$01 Return.

c $B123 Paint Background Yellow
R $B123 HL Attribute buffer address
N $B123 Paints two whole lines yellow, from a given attribute buffer address.
@ $B123 label=PaintYellow
  $B123,$02 #REGb=#N$40 (counter).
@ $B125 label=PaintYellow_Loop
  $B125,$02 Write #N$30 (#COLOUR$30) to *#REGhl.
  $B127,$01 Move onto the next attribute buffer column/ location.
  $B128,$02 Decrease counter by one and loop back to #R$B125 until counter is zero.
  $B12A,$01 Return.

c $B12B Update Timer Display
  $B12B,$03 #REGhl=#R$B146.
  $B12E,$01 Decrease *#REGhl by one.
  $B12F,$03 #REGa=*#R$C386.
  $B132,$02 Jump to #R$B140 if is not zero.
  $B134,$02 Test bit 4 of #REGa.
  $B136,$02 Write #N$02 to *#REGhl.
  $B138,$02 Jump to #R$B13C if bit 4 of #REGa is set.
  $B13A,$02 Write #N$19 to *#REGhl.
  $B13C,$03 Call #R$CB40.
  $B13F,$01 Return.
  $B140,$03 Return if bit 4 of #REGa is not set.
  $B143,$02 Write #N$01 to *#REGhl.
  $B145,$01 Return.
g $B146 Timer Display Counter
@ $B146 label=Timer_DisplayCounter
B $B146,$01

c $B147 Copy Playarea To Shadow Buffers
  $B147,$04 #REGix=*#R$C277.
  $B14B,$03 #REGl=*#REGix+#N$30.
  $B14E,$03 #REGh=*#REGix+#N$31.
  $B151,$04 #REGhl+=#N$0200.
  $B155,$03 #REGde=#R$7840.
  $B158,$03 #REGbc=#N$0410.
  $B15B,$03 Call #R$B1B2.
  $B15E,$03 #REGl=*#REGix+#N$18.
  $B161,$03 #REGh=*#REGix+#N$19.
  $B164,$04 #REGhl+=#N$0180.
  $B168,$03 #REGbc=#N$0C10.
  $B16B,$03 Call #R$B1B2.
  $B16E,$03 #REGl=*#REGix+#N$00.
  $B171,$03 #REGh=*#REGix+#N$01.
  $B174,$04 #REGhl+=#N$0180.
  $B178,$03 #REGbc=#N$0410.
  $B17B,$03 Call #R$B1B2.
  $B17E,$03 #REGl=*#REGix+#N$3C.
  $B181,$03 #REGh=*#REGix+#N$3D.
  $B184,$04 #REGhl+=#N$0200.
  $B188,$03 #REGde=#R$785F.
  $B18B,$03 #REGbc=#N$0410.
  $B18E,$03 Call #R$B1C3.
  $B191,$03 #REGl=*#REGix+#N$24.
  $B194,$03 #REGh=*#REGix+#N$25.
  $B197,$04 #REGhl+=#N$0180.
  $B19B,$03 #REGbc=#N$0C10.
  $B19E,$03 Call #R$B1C3.
  $B1A1,$03 #REGl=*#REGix+#N$0C.
  $B1A4,$03 #REGh=*#REGix+#N$0D.
  $B1A7,$04 #REGhl+=#N$0180.
  $B1AB,$03 #REGbc=#N$0410.
  $B1AE,$03 Call #R$B1C3.
  $B1B1,$01 Return.

c $B1B2 Copy Pixels To Shadow Buffer
  $B1B2,$02 Stash #REGbc and #REGde on the stack.
  $B1B4,$02 #REGb=#N$00.
  $B1B6,$02 Copy #REGhl to #REGde the number of times held by #REGbc.
  $B1B8,$01 Exchange the #REGde register with the shadow #REGhl register.
  $B1B9,$01 Restore #REGhl from the stack.
  $B1BA,$03 #REGbc=#N($0020,$04,$04).
  $B1BD,$01 #REGhl+=#REGbc.
  $B1BE,$01 Exchange the #REGde register with the shadow #REGhl register.
  $B1BF,$01 Restore #REGbc from the stack.
  $B1C0,$02 Decrease counter by one and loop back to #R$B1B2 until counter is zero.
  $B1C2,$01 Return.

c $B1C3 Copy Attributes To Shadow Buffer
  $B1C3,$02 Stash #REGbc and #REGde on the stack.
  $B1C5,$01 #REGa=*#REGhl.
  $B1C6,$01 Write #REGa to *#REGde.
  $B1C7,$01 Decrease #REGde by one.
  $B1C8,$01 Increment #REGhl by one.
  $B1C9,$01 Decrease #REGc by one.
  $B1CA,$02 Jump to #R$B1C5.
  $B1CC,$01 Exchange the #REGde register with the shadow #REGhl register.
  $B1CD,$01 Restore #REGhl from the stack.
  $B1CE,$03 #REGbc=#N($0020,$04,$04).
  $B1D1,$01 #REGhl+=#REGbc.
  $B1D2,$01 Exchange the #REGde register with the shadow #REGhl register.
  $B1D3,$01 Restore #REGbc from the stack.
  $B1D4,$02 Decrease counter by one and loop back to #R$B1C3 until counter is zero.
  $B1D6,$01 Return.

c $B1D7 Draw Object Sprite
  $B1D7,$03 #REGl=*#REGix+#N$00.
  $B1DA,$03 #REGh=*#REGix+#N$01.
  $B1DD,$02 Jump to #R$B1F2.

  $B1DF,$03 #REGl=*#REGix+#N$00.
  $B1E2,$03 #REGh=*#REGix+#N$01.
  $B1E5,$04 #REGhl+=#N$FE80.
  $B1E9,$01 Stash #REGhl on the stack.
  $B1EA,$03 #REGbc=#N$7820.
  $B1ED,$01 Set flags.
  $B1EE,$02 #REGhl-=#REGbc.
  $B1F0,$01 Restore #REGhl from the stack.
  $B1F1,$01 Return if the subtract had any carry.
  $B1F2,$05 Return if bit 6 of #REGix+#N$07 is set.
  $B1F7,$04 #REGhl+=#N($0020,$04,$04).
  $B1FB,$03 Call #R$C144.
  $B1FE,$03 #REGa=*#REGix+#N$02.
  $B201,$01 Write #REGa to *#REGhl.
  $B202,$01 Increment #REGhl by one.
  $B203,$03 #REGa=*#REGix+#N$03.
  $B206,$01 Write #REGa to *#REGhl.
  $B207,$01 Return.

c $B208 Copy Playarea To Screen
  $B208,$04 #REGix=*#R$C277.
  $B20C,$03 #REGl=*#REGix+#N$30.
  $B20F,$03 #REGh=*#REGix+#N$31.
  $B212,$04 #REGhl+=#N($0100,$04,$04).
  $B216,$03 #REGde=#R$7080.
  $B219,$03 #REGbc=#N$0420.
  $B21C,$03 Call #R$B293.
  $B21F,$02 Stash #REGix on the stack.
  $B221,$05 #REGix+=#N($0032,$04,$04).
  $B226,$03 Call #R$B1DF.
  $B229,$02 Restore #REGix from the stack.
  $B22B,$03 #REGl=*#REGix+#N$18.
  $B22E,$03 #REGh=*#REGix+#N$19.
  $B231,$03 #REGbc=#N$0C20.
  $B234,$03 Call #R$B293.
  $B237,$02 Stash #REGix on the stack.
  $B239,$05 #REGix+=#N($001A,$04,$04).
  $B23E,$03 Call #R$B1D7.
  $B241,$02 Restore #REGix from the stack.
  $B243,$03 #REGl=*#REGix+#N$00.
  $B246,$03 #REGh=*#REGix+#N$01.
  $B249,$03 #REGbc=#N$0420.
  $B24C,$03 Call #R$B293.
  $B24F,$03 #REGl=*#REGix+#N$3C.
  $B252,$03 #REGh=*#REGix+#N$3D.
  $B255,$04 #REGhl+=#N($0100,$04,$04).
  $B259,$03 #REGde=#R$70BF.
  $B25C,$03 #REGbc=#N$0410.
  $B25F,$03 Call #R$B2A4.
  $B262,$02 Stash #REGix on the stack.
  $B264,$05 #REGix+=#N($003E,$04,$04).
  $B269,$03 Call #R$B1DF.
  $B26C,$02 Restore #REGix from the stack.
  $B26E,$03 #REGl=*#REGix+#N$24.
  $B271,$03 #REGh=*#REGix+#N$25.
  $B274,$03 #REGbc=#N$0C10.
  $B277,$03 Call #R$B2A4.
  $B27A,$02 Stash #REGix on the stack.
  $B27C,$05 #REGix+=#N($0026,$04,$04).
  $B281,$03 Call #R$B1D7.
  $B284,$02 Restore #REGix from the stack.
  $B286,$03 #REGl=*#REGix+#N$0C.
  $B289,$03 #REGh=*#REGix+#N$0D.
  $B28C,$03 #REGbc=#N$0410.
  $B28F,$03 Call #R$B2A4.
  $B292,$01 Return.

c $B293 Playarea Copier
@ $B293 label=PlayareaCopier
R $B293 BC Number of bytes to copy (needs changing)
R $B293 DE Target address
R $B293 HL Source data
  $B293,$02 Stash #REGbc and #REGde on the stack.
  $B295,$02 #REGb=#N$00.
  $B297,$02 Copy #REGhl to #REGde the number of times held by #REGbc.
  $B299,$01 Exchange the #REGde register with the shadow #REGhl register.
  $B29A,$01 Restore #REGhl from the stack.
  $B29B,$04 #REGhl+=#N($0040,$04,$04).
  $B29F,$01 Switch the #REGde and #REGhl registers back.
  $B2A0,$01 Restore #REGbc from the stack.
  $B2A1,$02 Decrease counter by one and loop back to #R$B293 until counter is zero.
  $B2A3,$01 Return.

c $B2A4 Copy And Mirror Attributes
  $B2A4,$02 Stash #REGbc and #REGde on the stack.
  $B2A6,$01 Increment #REGhl by one.
  $B2A7,$01 #REGa=*#REGhl.
  $B2A8,$02,b$01 Flip bit 2.
  $B2AA,$01 Write #REGa to *#REGde.
  $B2AB,$01 Decrease #REGhl by one.
  $B2AC,$01 Decrease #REGde by one.
  $B2AD,$01 #REGa=*#REGhl.
  $B2AE,$01 Write #REGa to *#REGde.
  $B2AF,$02 Increment #REGhl by two.
  $B2B1,$01 Decrease #REGde by one.
  $B2B2,$01 Decrease #REGc by one.
  $B2B3,$02 Jump to #R$B2A6 until #REGc is zero.
  $B2B5,$01 Exchange the #REGde register with the shadow #REGhl register.
  $B2B6,$01 Restore #REGhl from the stack.
  $B2B7,$04 #REGhl+=#N($0040,$04,$04).
  $B2BB,$01 Exchange the #REGde register with the shadow #REGhl register.
  $B2BC,$01 Restore #REGbc from the stack.
  $B2BD,$02 Decrease counter by one and loop back to #R$B2A4 until counter is zero.
  $B2BF,$01 Return.

c $B2C0 Trashman Attribute Copier
@ $B2C0 label=TrashmanAttributes_Copier
E $B2C0 Continue on to #R$B2D1.
  $B2C0,$06 Load the attribute buffer location into #REGhl.
  $B2C6,$06 Load the height/ width into #REGbc.
  $B2CC,$03 Copy the attribute buffer location into #REGix (using the stack).
  $B2CF,$02 Set bit 5 of #REGh.

c $B2D1 Attributes Copier
@ $B2D1 label=Attributes_Copier
R $B2D1 HL Source pointer
R $B2D1 IX Destination pointer
R $B2D1 BC Width and height
  $B2D1,$03 #REGde=#N($0020,$04,$04).
  $B2D4,$04 Stash #REGhl, #REGix and #REGbc on the stack.
  $B2D8,$01 #REGa=*#REGhl.
  $B2D9,$02,b$01 Keep only bits 0-6.
  $B2DB,$03 Write #REGa to *#REGix+#N$00.
  $B2DE,$01 #REGhl+=#REGde.
  $B2DF,$02 #REGix+=#REGde.
  $B2E1,$02 Decrease counter by one and loop back to #R$B2D8 until counter is zero.
  $B2E3,$04 Restore #REGbc, #REGix and #REGhl from the stack.
  $B2E7,$02 Increment #REGix by one.
  $B2E9,$01 Increment #REGhl by one.
  $B2EA,$01 Decrease #REGc by one.
  $B2EB,$02 Jump to #R$B2D1.
  $B2ED,$01 Return.

c $B2EE Draw Street Object
  $B2EE,$03 #REGl=*#REGix+#N$05.
  $B2F1,$03 #REGh=*#REGix+#N$06.
  $B2F4,$03 #REGc=*#REGix+#N$04.
  $B2F7,$03 #REGb=*#REGix+#N$03.
  $B2FA,$03 #REGix=#REGhl (using the stack).
  $B2FD,$02 Set bit 5 of #REGh.
  $B2FF,$03 #REGde=#N($0020,$04,$04).
  $B302,$04 Stash #REGhl, #REGix and #REGbc on the stack.
  $B306,$01 #REGa=*#REGhl.
  $B307,$04 Jump to #R$B312 if bit 6 of #REGa is set.
  $B30B,$02,b$01 Keep only bits 0-5.
  $B30D,$02,b$01 Set bit 6.
  $B30F,$03 Write #REGa to *#REGix+#N$00.
  $B312,$01 #REGhl+=#REGde.
  $B313,$02 #REGix+=#REGde.
  $B315,$02 Decrease counter by one and loop back to #R$B306 until counter is zero.
  $B317,$04 Restore #REGbc, #REGix and #REGhl from the stack.
  $B31B,$02 Increment #REGix by one.
  $B31D,$01 Increment #REGhl by one.
  $B31E,$01 Decrease #REGc by one.
  $B31F,$02 Jump to #R$B2FF.
  $B321,$01 Return.

c $B322 Draw Street Object Sprite
  $B322,$03 #REGl=*#REGix+#N$05.
  $B325,$03 #REGa=*#REGix+#N$06.
  $B328,$02,b$01 Keep only bits 0-1.
  $B32A,$02,b$01 Set bits 3-5.
  $B32C,$01 #REGh=#REGa.
  $B32D,$01 #REGhl+=#REGhl.
  $B32E,$03 #REGe=*#REGix+#N$01.
  $B331,$03 #REGd=*#REGix+#N$02.
  $B334,$03 #REGc=*#REGix+#N$03.
  $B337,$03 #REGb=*#REGix+#N$04.
  $B33A,$04 Stash #REGbc, #REGde, #REGhl and #REGhl on the stack.
  $B33E,$01 #REGb=*#REGhl.
  $B33F,$01 Increment #REGhl by one.
  $B340,$01 #REGh=*#REGhl.
  $B341,$04 Jump to #R$B36E if bit 7 of #REGh is not set.
  $B345,$01 #REGl=#REGb.
  $B346,$02 #REGb=#N$08.
  $B348,$01 #REGa=*#REGhl.
  $B349,$01 Write #REGa to *#REGde.
  $B34A,$01 Increment #REGhl by one.
  $B34B,$01 Increment #REGd by one.
  $B34C,$02 Decrease counter by one and loop back to #R$B348 until counter is zero.
  $B34E,$01 Decrease #REGc by one.
  $B34F,$02 Jump to #R$B364 if #REGc is zero.
  $B351,$04 #REGe+=#N$20.
  $B355,$02 Jump to #R$B35B if {} is lower.
  $B357,$04 #REGd-=#N$08.
  $B35B,$01 Restore #REGhl from the stack.
  $B35C,$01 #REGa=#REGc.
  $B35D,$04 #REGhl+=#N($0040,$04,$04).
  $B361,$01 #REGc=#REGa.
  $B362,$02 Jump to #R$B33D.
  $B364,$04 Restore #REGhl, #REGhl, #REGde and #REGbc from the stack.
  $B368,$01 Increment #REGe by one.
  $B369,$02 Increment #REGl by two.
  $B36B,$02 Decrease counter by one and loop back to #R$B33A until counter is zero.
  $B36D,$01 Return.
N $B36E
  $B36E,$04 #REGd+=#N$08.
  $B372,$02 Jump to #R$B34E.

c $B374 Draw Trashman Sprite
@ $B374 label=DrawTrashmanSprite
E $B374 Continue on to #R$B38C.
N $B374 Calculate Trashmans sprite graphics pointer.
  $B374,$03 #REGl=*#REGix+#N$05.
  $B377,$03 #REGa=*#REGix+#N$06.
  $B37A,$02,b$01 Keep only bits 0-1.
  $B37C,$03,b$01 Set bits 3-5 to add the graphics address base.
  $B37F,$01 Double the value in #REGhl.
  $B380,$06 Load Trashmans screen address into #REGde.
  $B386,$06 Set the sprite height/ width in #REGbc.

c $B38C Pixels Copier
@ $B38C label=Copier_Pixels
R $B38C HL Source pointer
R $B38C DE Destination pointer
R $B38C BC Width and height
  $B38C,$04 Stash #REGbc, #REGde, #REGhl and #REGhl on the stack.
  $B390,$01 #REGb=*#REGhl.
  $B391,$01 Increment #REGhl by one.
  $B392,$01 #REGh=*#REGhl.
  $B393,$02 Set bit 7 of #REGh.
  $B395,$01 #REGl=#REGb.
  $B396,$02 #REGb=#N$08.
  $B398,$01 #REGa=*#REGhl.
  $B399,$01 Write #REGa to *#REGde.
  $B39A,$01 Increment #REGhl by one.
  $B39B,$01 Increment #REGd by one.
  $B39C,$02 Decrease counter by one and loop back to #R$B398 until counter is zero.
  $B39E,$01 Decrease #REGc by one.
  $B39F,$02 Jump to #R$B3B4 if {} is zero.
  $B3A1,$04 #REGe+=#N$20.
  $B3A5,$02 Jump to #R$B3AB if {} is lower.
  $B3A7,$04 #REGd-=#N$08.
  $B3AB,$01 Restore #REGhl from the stack.
  $B3AC,$01 #REGa=#REGc.
  $B3AD,$03 #REGbc=#N($0040,$04,$04).
  $B3B0,$01 #REGhl+=#REGbc.
  $B3B1,$01 #REGc=#REGa.
  $B3B2,$02 Jump to #R$B38F.
  $B3B4,$04 Restore #REGhl, #REGhl, #REGde and #REGbc from the stack.
  $B3B8,$01 Increment #REGe by one.
  $B3B9,$02 Increment #REGl by two.
  $B3BB,$02 Decrease counter by one and loop back to #R$B38C until counter is zero.
  $B3BD,$01 Return.

c $B3BE Update Street Object Attributes
  $B3BE,$04 #REGix=#R$C2EE.
  $B3C2,$02 #REGb=#N$08.
  $B3C4,$01 Stash #REGbc on the stack.
  $B3C5,$03 #REGa=*#REGix+#N$00.
  $B3C8,$03 Compare #REGa with *#REGix+#N$0B.
  $B3CB,$02 Jump to #R$B3E7 if {} is higher.
  $B3CD,$03 Call #R$C057.
  $B3D0,$03 #REGl=*#REGix+#N$05.
  $B3D3,$03 #REGh=*#REGix+#N$06.
  $B3D6,$02 Set bit 5 of #REGh.
  $B3D8,$03 #REGbc=#N($001F,$04,$04).
  $B3DB,$03 #REGa=*#REGix+#N$03.
  $B3DE,$02 Set bit 6 of *#REGhl.
  $B3E0,$01 Increment #REGl by one.
  $B3E1,$02 Set bit 6 of *#REGhl.
  $B3E3,$01 #REGhl+=#REGbc.
  $B3E4,$01 Decrease #REGa by one.
  $B3E5,$02 Jump to #R$B3DE if {} is not zero.
  $B3E7,$05 #REGix+=#N($000D,$04,$04).
  $B3EC,$01 Restore #REGbc from the stack.
  $B3ED,$02 Decrease counter by one and loop back to #R$B3C4 until counter is zero.
  $B3EF,$01 Return.

c $B3F0 Handler: Street Objects
@ $B3F0 label=Handler_StreetObjects
  $B3F0,$04 #REGix=#R$C293.
  $B3F4,$02 Set a counter in #REGb for the number of street objects (#N$07).
@ $B3F6 label=StreetObjects_Loop
  $B3F6,$01 Stash the street objects counter on the stack.
  $B3F7,$03 #REGa=*#REGix+#N$00.
  $B3FA,$03 Compare #REGa with *#REGix+#N$0B.
  $B3FD,$03 Call #R$B409 is lower.
  $B400,$05 Add #N($000D,$04,$04) to the street objects pointer to move to the
. next object.
  $B405,$01 Restore the street objects counter from the stack.
  $B406,$02 Decrease the street objects counter by one and loop back to #R$B3F6
. until all of the street objects have been processed.
  $B408,$01 Return.
N $B409 Time for the street object to update.
@ $B409 label=StreetObjects_Action
  $B409,$02 Stash the street objects pointer on the stack.
  $B40B,$03 Call #R$B2EE.
  $B40E,$02 Restore the street objects pointer from the stack.
  $B410,$03 Call #R$B322.
  $B413,$02 #REGa=#N$17.
  $B415,$01 Return.

c $B416 Place Trashman
@ $B416 label=PlaceTrashman
  $B416,$04 #REGix=#R$C36E.
  $B41A,$06 Jump to #R$B425 if bit 0 of *#REGix+#N$18 is not set.
  $B420,$05 Return if bit 7 of *#REGix+#N$18 is set.
  $B425,$04 Reset bit 7 of *#REGix+#N$18.
  $B429,$03 Call #R$B2C0.
  $B42C,$04 #REGix=#R$C36E.
  $B430,$03 Call #R$B374.
  $B433,$06 Jump to #R$B440 if bit 1 of *#REGix+#N$17 is set.
  $B439,$03 Call #R$B4B8.
  $B43C,$03 Call #R$B469.
  $B43F,$01 Return.
  $B440,$05 Return if bit 0 of *#REGix+#N$18 is not set.
  $B445,$04 Set bit 7 of *#REGix+#N$18.
  $B449,$01 Return.

c $B44A Place Secondary Character
  $B44A,$04 #REGix=#R$C356.
  $B44E,$05 Return if bit 3 of *#REGix+#N$17 is not set.
  $B453,$03 Call #R$B2C0.
  $B456,$04 #REGix=#R$C356.
  $B45A,$03 Call #R$B374.
  $B45D,$05 Return if bit 1 of *#REGix+#N$17 is set.
  $B462,$03 Call #R$B4B8.
  $B465,$03 Call #R$B469.
  $B468,$01 Return.

c $B469 Draw Character Mask
  $B469,$03 #REGe=*#REGix+#N$08.
  $B46C,$03 #REGd=*#REGix+#N$09.
  $B46F,$03 #REGl=*#REGix+#N$0E.
  $B472,$03 #REGh=*#REGix+#N$0F.
  $B475,$03 #REGc=*#REGix+#N$0A.
  $B478,$01 Decrease #REGc by one.
  $B479,$03 #REGb=*#REGix+#N$0B.
  $B47C,$03 Stash #REGbc, #REGde and #REGhl on the stack.
  $B47F,$02 #REGb=#N$08.
  $B481,$01 #REGa=*#REGde.
  $B482,$01 Merge the bits from *#REGhl.
  $B483,$01 Increment #REGhl by one.
  $B484,$01 Set the bits from *#REGhl.
  $B485,$01 Write #REGa to *#REGde.
  $B486,$01 Increment #REGhl by one.
  $B487,$01 Increment #REGd by one.
  $B488,$02 Decrease counter by one and loop back to #R$B481 until counter is zero.
  $B48A,$01 Decrease #REGc by one.
  $B48B,$03 Jump to #R$B4A2 M.
  $B48E,$02 Jump to #R$B496 if {} is not zero.
  $B490,$04 Shift *#REGix+#N$17 left (with carry).
  $B494,$02 Jump to #R$B4A2 if {} is lower.
  $B496,$01 #REGa=#REGe.
  $B497,$02 #REGa+=#N$20.
  $B499,$01 #REGe=#REGa.
  $B49A,$02 Jump to #R$B47F if {} is lower.
  $B49C,$01 #REGa=#REGd.
  $B49D,$02 #REGa-=#N$08.
  $B49F,$01 #REGd=#REGa.
  $B4A0,$02 Jump to #R$B47F.
  $B4A2,$01 Restore #REGhl from the stack.
  $B4A3,$02 #REGd=#N$00.
  $B4A5,$03 #REGe=*#REGix+#N$16.
  $B4A8,$01 #REGhl+=#REGde.
  $B4A9,$01 Restore #REGde from the stack.
  $B4AA,$01 Increment #REGe by one.
  $B4AB,$01 Restore #REGbc from the stack.
  $B4AC,$02 Decrease counter by one and loop back to #R$B47C until counter is zero.
  $B4AE,$03 #REGb=*#REGix+#N$0B.
  $B4B1,$04 Shift *#REGix+#N$17 right.
  $B4B5,$02 Decrease counter by one and loop back to #R$B4B1 until counter is zero.
  $B4B7,$01 Return.

c $B4B8 Check Character Collision
  $B4B8,$03 #REGb=*#REGix+#N$0B.
  $B4BB,$03 #REGl=*#REGix+#N$0C.
  $B4BE,$03 #REGh=*#REGix+#N$0D.
  $B4C1,$03 #REGde=#N($0020,$04,$04).
  $B4C4,$01 Stash #REGhl on the stack.
  $B4C5,$03 #REGc=*#REGix+#N$0A.
  $B4C8,$01 Decrease #REGc by one.
  $B4C9,$01 #REGa=*#REGhl.
  $B4CA,$02,b$01 Keep only bits 3-6.
  $B4CC,$03 Set the bits of #REGa with *#REGix+#N$12.
  $B4CF,$01 Write #REGa to *#REGde.
  $B4D0,$01 #REGhl+=#REGde.
  $B4D1,$01 Decrease #REGc by one.
  $B4D2,$03 Jump to #R$B4EE M.
  $B4D5,$02 Jump to #R$B4C9 if {} is not zero.
  $B4D7,$01 #REGa=*#REGhl.
  $B4D8,$02 Compare #REGa with #N$20.
  $B4DA,$02 Jump to #R$B4E9 if {} is zero.
  $B4DC,$02,b$01 Keep only bits 0-5.
  $B4DE,$02 Compare #REGa with #N$28.
  $B4E0,$02 Jump to #R$B4E9 if {} is zero.
  $B4E2,$01 Set flags.
  $B4E3,$04 Rotate *#REGix+#N$17 left.
  $B4E7,$02 Jump to #R$B4C9.
  $B4E9,$01 Set the carry flag.
  $B4EA,$04 Rotate *#REGix+#N$17 left.
  $B4EE,$01 Restore #REGhl from the stack.
  $B4EF,$01 Increment #REGl by one.
  $B4F0,$02 Decrease counter by one and loop back to #R$B4C4 until counter is zero.
  $B4F2,$03 #REGb=*#REGix+#N$0B.
  $B4F5,$04 Rotate *#REGix+#N$17 right (with carry).
  $B4F9,$02 Decrease counter by one and loop back to #R$B4F5 until counter is zero.
  $B4FB,$01 Return.
  $B4FC,$02 #REGa=#N$03.
  $B4FE,$04 Return if #REGa is higher than *#REGix+#N$07.
  $B502,$03 #REGde=#R$FFE8.
  $B505,$03 Call #R$B64C.
  $B508,$03 #REGa=*#R$C276.
  $B50B,$02 #REGa-=#N$0C.
  $B50D,$03 #REGa=#R$C276.
  $B510,$03 #REGl=*#REGix+#N$10.
  $B513,$03 #REGh=*#REGix+#N$11.
  $B516,$03 #REGde=#R$FE80.
  $B519,$01 #REGhl+=#REGde.
  $B51A,$03 Write #REGl to *#REGix+#N$10.
  $B51D,$03 Write #REGh to *#REGix+#N$11.
  $B520,$03 Write #REGb to *#REGix+#N$13.
  $B523,$01 Restore #REGhl from the stack.
  $B524,$03 Call #R$B8A6.
  $B527,$04 #REGix=#R$C2EE.
  $B52B,$02 #REGb=#N$08.
  $B52D,$03 #REGde=#N($000D,$04,$04).
  $B530,$03 #REGa=*#REGix+#N$00.
  $B533,$02 #REGa+=#N$0C.
  $B535,$03 Write #REGa to *#REGix+#N$00.
  $B538,$02 #REGix+=#REGde.
  $B53A,$02 Decrease counter by one and loop back to #R$B530 until counter is zero.
  $B53C,$04 #REGix=#R$C293.
  $B540,$02 #REGb=#N$04.
  $B542,$03 #REGhl=#R$C38C.
  $B545,$03 #REGde=#N($000D,$04,$04).
  $B548,$03 #REGa=*#REGix+#N$00.
  $B54B,$02 #REGa+=#N$0C.
  $B54D,$03 Jump to #R$B557 if #REGa is higher than *#REGhl.
  $B550,$04 Jump to #R$B557 if #REGa is lower than #N$20.
  $B554,$01 #REGa+=*#REGhl.
  $B555,$02 #REGa-=#N$20.
  $B557,$03 Write #REGa to #REGix+#N$00.
  $B55A,$02 #REGix+=#REGde.
  $B55C,$02 Decrease counter by one and loop back to #R$B548 until counter is zero.
  $B55E,$02 #REGb=#N$03.
  $B560,$03 #REGa=*#REGix+#N$00.
  $B563,$02 #REGa+=#N$0C.
  $B565,$03 Write #REGa to *#REGix+#N$00.
  $B568,$02 #REGix+=#REGde.
  $B56A,$02 Decrease counter by one and loop back to #R$B560 until counter is zero.
  $B56C,$03 Jump to #R$B603.
  $B56F,$04 #REGix=#R$C38D.
  $B573,$03 #REGde=#N($000C,$04,$04).
  $B576,$03 #REGa=*#R$C27A.
  $B579,$01 #REGb=#REGa.
  $B57A,$06 Jump to #R$B58B if bit 7 of *#REGix+#N$21 is not set.
  $B580,$02 #REGix+=#REGde.
  $B582,$02 Decrease counter by one and loop back to #R$B57A until counter is zero.
  $B584,$01 Restore #REGhl from the stack.
  $B585,$03 #REGhl=#R$B008.
  $B588,$02 Set bit 1 of *#REGhl.
  $B58A,$01 Return.
  $B58B,$03 #REGhl=#R$C1FB.
  $B58E,$03 Jump to #R$BC9E.

c $B591 Scroll Playarea
N $B591 #PUSHS #SIM(start=$A5AC,stop=$A5B5)#SIM(start=$A5B8,stop=$A5BE)
. #SIM(start=$B0A1,stop=$B646)
. #UDGTABLE
. { #SCR$02(gameplay) }
. TABLE# #POPS
  $B591,$03 #REGa=*#R$C279.
  $B594,$05 Jump to #R$B56F if #REGa is lower than *#REGix+#N$07.
  $B599,$03 #REGde=#N($0018,$04,$04).
  $B59C,$03 Call #R$B64C.
  $B59F,$03 #REGa=*#R$C276.
  $B5A2,$02 #REGa+=#N$0C.
  $B5A4,$03 Write #REGa back to *#R$C276.
  $B5A7,$03 #REGl=*#REGix+#N$10.
  $B5AA,$03 #REGh=*#REGix+#N$11.
  $B5AD,$03 #REGde=#N($0180,$04,$04).
  $B5B0,$01 #REGhl+=#REGde.
  $B5B1,$03 Write #REGl to *#REGix+#N$10.
  $B5B4,$03 Write #REGh to *#REGix+#N$11.
  $B5B7,$03 Write #REGb to *#REGix+#N$13.
  $B5BA,$01 Restore #REGhl from the stack.
  $B5BB,$03 Call #R$B8A6.
  $B5BE,$04 #REGix=#R$C2EE.
  $B5C2,$02 #REGb=#N$08 (counter).
  $B5C4,$03 #REGde=#N($000D,$04,$04).
  $B5C7,$03 #REGa=*#REGix+#N$00.
  $B5CA,$02 #REGa-=#N$0C.
  $B5CC,$03 Write #REGa to *#REGix+#N$00.
  $B5CF,$02 #REGix+=#REGde.
  $B5D1,$02 Decrease counter by one and loop back to #R$B5C7 until counter is zero.
  $B5D3,$04 #REGix=#R$C293.
  $B5D7,$02 #REGb=#N$04.
  $B5D9,$03 #REGde=#N($000D,$04,$04).
  $B5DC,$03 #REGhl=#R$C38C.
  $B5DF,$03 #REGa=*#REGix+#N$00.
  $B5E2,$02 #REGa-=#N$0C.
  $B5E4,$03 Jump to #R$B5EE if #REGa is higher than *#REGhl.
  $B5E7,$04 Jump to #R$B5EE if #REGa is lower than #N$20.
  $B5EB,$01 #REGa-=*#REGhl.
  $B5EC,$02 #REGa+=#N$20.
  $B5EE,$03 Write #REGa to *#REGix+#N$00.
  $B5F1,$02 #REGix+=#REGde.
  $B5F3,$02 Decrease counter by one and loop back to #R$B5DF until counter is zero.
  $B5F5,$02 #REGb=#N$03.
  $B5F7,$03 #REGa=*#REGix+#N$00.
  $B5FA,$02 #REGa-=#N$0C.
  $B5FC,$03 Write #REGa to *#REGix+#N$00.
  $B5FF,$02 #REGix+=#REGde.
  $B601,$02 Decrease counter by one and loop back to #R$B5F7 until counter is zero.
  $B603,$03 Call #R$B208.
  $B606,$03 Call #R$B147.
  $B609,$03 Call #R$B3BE.
  $B60C,$04 #REGix=#R$C293.
  $B610,$02 #REGb=#N$07.
  $B612,$01 Stash #REGbc on the stack.
  $B613,$03 Call #R$C057.
  $B616,$05 #REGix+=#N($000D,$04,$04).
  $B61B,$01 Restore #REGbc from the stack.
  $B61C,$02 Decrease counter by one and loop back to #R$B612 until counter is zero.
  $B61E,$04 #REGix=#R$C2D4.
  $B622,$03 Call #R$BD27.
  $B625,$05 #REGix+=#N($000D,$04,$04).
  $B62A,$03 Call #R$BD27.
  $B62D,$03 #REGhl=#R$7080.
  $B630,$03 #REGbc=#N$2014.
  $B633,$03 #REGde=#N$4040 (screen buffer location).
  $B636,$03 Call #R$B38C.
  $B639,$03 #REGhl=#R$7840.
  $B63C,$04 #REGix=#R$5840 (attribute buffer location).
  $B640,$03 #REGbc=#N$1420.
  $B643,$03 Call #R$B2D1.
  $B646,$03 Call #R$B416.
  $B649,$03 Jump to #R$B0BB.

c $B64C Reposition Trashman
  $B64C,$02 Stash #REGix on the stack.
  $B64E,$04 #REGix=*#R$C277.
  $B652,$04 Reset bit 1 of *#REGix+#N$21.
  $B656,$04 Reset bit 1 of *#REGix+#N$2D.
  $B65A,$04 Set bit 3 of *#REGix+#N$21.
  $B65E,$04 Set bit 3 of *#REGix+#N$2D.
  $B662,$02 #REGix+=#REGde.
  $B664,$04 Write #REGix to *#R$C277.
  $B668,$04 Test bit 5 of *#REGix+#N$21.
  $B66C,$02 #REGl=#N$28.
  $B66E,$02 Jump to #R$B677 if bit 5 is set.
  $B670,$03 #REGde=#N($000C,$04,$04).
  $B673,$02 #REGix+=#REGde.
  $B675,$02 #REGl=#N$D8.
  $B677,$03 #REGa=*#REGix+#N$20.
  $B67A,$01 #REGc=#REGa.
  $B67B,$01 RRCA.
  $B67C,$02 Rotate #REGl right.
  $B67E,$01 RRCA.
  $B67F,$02 Rotate #REGl right.
  $B681,$01 RRCA.
  $B682,$02 Rotate #REGl right.
  $B684,$02,b$01 Set bits 5-6.
  $B686,$04 #REGix=#R$C356.
  $B68A,$03 Write #REGl to *#REGix+#N$10.
  $B68D,$03 Write #REGa to *#REGix+#N$11.
  $B690,$04 Write #N$13 to *#REGix+#N$13.
  $B694,$02 #REGa=#N$1F.
  $B696,$01 Merge the bits from #REGc.
  $B697,$02 NEG.
  $B699,$02 #REGa+=#N$15.
  $B69B,$03 Write #REGa to *#REGix+#N$07.
  $B69E,$03 Write #REGa to *#R$B918.
  $B6A1,$02 #REGc=#N$22.
  $B6A3,$02 #REGa=#N$05.
  $B6A5,$04 Jump to #R$B6AD if bit 4 of #REGl is not set.
  $B6A9,$02 #REGc=#N$02.
  $B6AB,$02 #REGa=#N$1A.
  $B6AD,$03 Write #REGc to *#REGix+#N$17.
  $B6B0,$03 Write #REGa to *#R$B917.
  $B6B3,$02 Restore #REGix from the stack.
  $B6B5,$03 #REGhl=#R$C389.
  $B6B8,$02 Reset bit 0 of *#REGhl.
  $B6BA,$01 Return.

c $B6BB Handler: Controls
@ $B6BB label=Handler_Controls
N $B6BB Self-modifying code, the target address here is updated from #R$A6C0 to set the selected controller routine.
N $B6BB This will be one of the following: #TABLE(default) { #R$B6BF } { #R$B6E5 } { #R$B703 } TABLE#
  $B6BB,$03 Call #R$B6BF.
  $B6BE,$01 Return.

c $B6BF Handler: Controls Keyboard
@ $B6BF label=Handler_Controls_Keyboard
R $B6BF E Control response
N $B6BF "Left" is handled by a different port to the other control keys.
  $B6BF,$05 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$F7 | 1 | 2 | 3 | 4 | 5 }
. TABLE#
N $B6C4 Handles "left" action.
  $B6C4,$02 #REGe=#N$10.
  $B6C6,$03 Return if "5" (left) was pressed.
N $B6C9 Handle "right", "down", "up" and "fire".
  $B6C9,$05 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$EF | 0 | 9 | 8 | 7 | 6 }
. TABLE#
N $B6CE Handles "right" action.
  $B6CE,$02 #REGe=#N$00.
  $B6D0,$03 Return if "8" (right) was pressed.
N $B6D3 Handles "down" action.
  $B6D3,$02 #REGe=#N$08.
  $B6D5,$03 Return if "6" (down) was pressed.
N $B6D8 Handles "up" action.
  $B6D8,$02 #REGe=#N$18.
  $B6DA,$03 Return if "7" (up) was pressed.
N $B6DD Handles "fire" action.
  $B6DD,$02 #REGe=#N$80.
  $B6DF,$03 Return if "0" (fire) was pressed.
N $B6E2 Handle no action.
  $B6E2,$02 #REGe=#N$C0.
  $B6E4,$01 Return.

c $B6E5 Handler: Controls Kempston Joystick
@ $B6E5 label=Handler_Controls_Kempston
R $B6E5 E Control response
  $B6E5,$02 #REGa=controls.
N $B6E7 Handles "left" action.
  $B6E7,$02 #REGe=#N$10.
  $B6E9,$03 Return if "left" was pressed.
N $B6EC Handles "right" action.
  $B6EC,$02 #REGe=#N$00.
  $B6EE,$03 Return if "right" was pressed.
N $B6F1 Handles "down" action.
  $B6F1,$02 #REGe=#N$08.
  $B6F3,$03 Return if "down" was pressed.
N $B6F6 Handles "up" action.
  $B6F6,$02 #REGe=#N$18.
  $B6F8,$03 Return if "up" was pressed.
N $B6FB Handles "fire" action.
  $B6FB,$02 #REGe=#N$80.
  $B6FD,$03 Return if "fire" was pressed.
N $B700 Handle no action.
  $B700,$02 #REGe=#N$C0.
  $B702,$01 Return.

c $B703 Handler: Controls Interface 2 Joystick
@ $B703 label=Handler_Controls_Interface2
R $B703 E Control response
  $B703,$05 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$EF | 0 | 9 | 8 | 7 | 6 }
. TABLE#
N $B708 Handles "left" action.
  $B708,$02 #REGe=#N$10.
  $B70A,$03 Return if "6" (left) was pressed.
N $B70D Handles "right" action.
  $B70D,$02 #REGe=#N$00.
  $B70F,$03 Return if "7" (right) was pressed.
N $B712 Handles "down" action.
  $B712,$02 #REGe=#N$08.
  $B714,$03 Return if "8" (down) was pressed.
N $B717 Handles "up" action.
  $B717,$02 #REGe=#N$18.
  $B719,$03 Return if "9" (up) was pressed.
N $B71C Handles "fire" action.
  $B71C,$02 #REGe=#N$80.
  $B71E,$03 Return if "0" (fire) was pressed.
N $B721 Handle no action.
  $B721,$02 #REGe=#N$C0.
  $B723,$01 Return.

c $B724 Handle Trashman Movement
  $B724,$03 #REGde=#R$C36E.
  $B727,$03 #REGhl=#R$C375.
  $B72A,$03 #REGbc=#N($0007,$04,$04).
  $B72D,$02 LDIR.
  $B72F,$03 #REGhl=#R$C28E.
  $B732,$01 Decrease *#REGhl by one.
  $B733,$01 Return if {} is not zero.
  $B734,$02 Write #N$06 to *#REGhl.
  $B736,$01 Increment #REGhl by one.
  $B737,$01 Decrease *#REGhl by one.
  $B738,$01 Return if {} is not zero.
  $B739,$02 Write #N$01 to *#REGhl.
  $B73B,$04 #REGix=#R$C36E.
  $B73F,$01 Increment #REGhl by one.
  $B740,$01 Decrease *#REGhl by one.
  $B741,$02 Jump to #R$B74B if {} is not zero.
  $B743,$02 Write #N$01 to *#REGhl.
  $B745,$04 Reset bit 5 of *#REGix+#N$17.
  $B749,$02 Jump to #R$B75D.
  $B74B,$04 Set bit 5 of *#REGix+#N$17.
  $B74F,$06 Jump to #R$B75D if bit 5 of *#REGix+#N$13 is set.
  $B755,$03 #REGa=*#R$C28E.
  $B758,$02 #REGa+=#N$06.
  $B75A,$03 Write #REGa to *#R$C28E.
  $B75D,$06 Jump to #R$B76D if bit 4 of *#REGix+#N$17 is not set.
  $B763,$03 #REGa=*#R$C28E.
  $B766,$02 #REGa+=#N$04.
  $B768,$03 Write #REGa to *#R$C28E.
  $B76B,$02 Jump to #R$B781.
  $B76D,$06 Jump to #R$B77B if bit 1 of *#REGix+#N$17 is not set.
  $B773,$01 Increment #REGhl by one.
  $B774,$02 Write #N$01 to *#REGhl.
  $B776,$01 Increment #REGhl by one.
  $B777,$02 Write #N$01 to *#REGhl.
  $B779,$02 Jump to #R$B7A1.
  $B77B,$01 Increment #REGhl by one.
  $B77C,$01 Decrease *#REGhl by one.
  $B77D,$02 Jump to #R$B763 if *#REGhl is set.
  $B77F,$02 Write #N$01 to *#REGhl.
  $B781,$01 Increment #REGhl by one.
  $B782,$01 Decrease *#REGhl by one.
  $B783,$02 Jump to #R$B79F if *#REGhl is zero.
  $B785,$04 Jump to #R$B7A1 if bit 1 of *#REGhl is not set.
  $B789,$02 Test bit 0 of *#REGhl.
  $B78B,$03 #REGa=*#REGix+#N$13.
  $B78E,$02 Jump to #R$B79A if bit 0 of *#REGhl is set.
  $B790,$03 Call #R$C1CD.
  $B793,$04 #REGix=#R$C36E.
  $B797,$03 #REGa=*#R$C1E5.
  $B79A,$02,b$01 Keep only bits 3-4.
  $B79C,$01 #REGe=#REGa.
  $B79D,$02 Jump to #R$B7A7.
  $B79F,$02 Write #N$01 to *#REGhl.
  $B7A1,$03 Call #R$B6BB.
  $B7A4,$03 Return if bit 7 of #REGe is set.
  $B7A7,$06 Jump to #R$B7CB if bit 0 of *#REGix+#N$18 is not set.
  $B7AD,$02 #REGa=#N$08.
  $B7AF,$01 Compare #REGa with #REGe.
  $B7B0,$01 Return if {} is not zero.
  $B7B1,$04 Reset bit 1 of *#REGix+#N$17.
  $B7B5,$03 #REGhl=*#R$C277.
  $B7B8,$03 #REGbc=#N($0021,$04,$04).
  $B7BB,$06 Jump to #R$B7C4 if bit 4 of *#REGix+#N$10 is not set.
  $B7C1,$03 #REGbc=#N($002D,$04,$04).
  $B7C4,$01 #REGhl+=#REGbc.
  $B7C5,$02 Set bit 2 of *#REGhl.
  $B7C7,$02,b$01 Set bits 6.
  $B7C9,$02 Jump to #R$B7E4.
  $B7CB,$03 #REGhl=*#R$C277.
  $B7CE,$03 #REGbc=#N($0021,$04,$04).
  $B7D1,$06 Jump to #R$B7DA if bit 4 of *#REGix+#N$10 is not set.
  $B7D7,$03 #REGbc=#N($002D,$04,$04).
  $B7DA,$01 #REGhl+=#REGbc.
  $B7DB,$04 Jump to #R$B7E1 if bit 1 of *#REGhl is set.
  $B7DF,$02 Set bit 3 of *#REGhl.
  $B7E1,$03 #REGa=*#REGix+#N$13.
  $B7E4,$01 #REGb=#REGa.
  $B7E5,$02,b$01 Keep only bits 3-4.
  $B7E7,$03 Jump to #R$B7F3 if #REGa is equal to #REGe.
  $B7EA,$01 #REGa=#REGb.
  $B7EB,$02,b$01 Keep only bits 6.
  $B7ED,$01 Set the bits from #REGe.
  $B7EE,$03 Write #REGa to *#REGix+#N$13.
  $B7F1,$02 Jump to #R$B7FC.
  $B7F3,$04 Jump to #R$B81E if bit 5 of #REGb is not set.
  $B7F7,$02 Reset bit 5 of #REGb.
  $B7F9,$03 Write #REGb to *#REGix+#N$13.
  $B7FC,$06 Jump to #R$B809 if bit 0 of *#REGix+#N$17 is set.
  $B802,$07 Jump to #R$B8A6 if bit 2 of *#REGix+#N$17 is not set.
  $B809,$04 Test bit 3 of *#REGix+#N$17.
  $B80D,$02 #REGa=#N$02.
  $B80F,$02 Jump to #R$B813 if bit 3 of *#REGix+#N$17 is not set.
  $B811,$02 #REGa=#N$00.
  $B813,$03 Set the bits of #REGa with *#REGix+#N$17.
  $B816,$02,b$01 Keep only bits 1, 3-7.
  $B818,$03 Write #REGa to *#REGix+#N$17.
  $B81B,$03 Jump to #R$B8A6.
  $B81E,$03 #REGhl=#R$C1E7.
  $B821,$02 Shift #REGe right (with carry).
  $B823,$02 Shift #REGe right (with carry).
  $B825,$02 #REGd=#N$00.
  $B827,$01 #REGhl+=#REGde.
  $B828,$01 #REGe=*#REGhl.
  $B829,$01 Increment #REGhl by one.
  $B82A,$01 #REGd=*#REGhl.
  $B82B,$03 #REGl=*#REGix+#N$10.
  $B82E,$03 #REGh=*#REGix+#N$11.
  $B831,$01 #REGhl+=#REGde.
  $B832,$04 Jump to #R$B870 if bit 7 of *#REGhl is set.
  $B836,$01 Stash #REGhl on the stack.
  $B837,$03 #REGde=#R$78A0.
  $B83A,$01 Set flags.
  $B83B,$02 #REGhl-=#REGde (with carry).
  $B83D,$01 Restore #REGhl from the stack.
  $B83E,$03 Jump to #R$B591 if {} is lower.
  $B841,$01 Stash #REGhl on the stack.
  $B842,$03 #REGde=#R$7A60.
  $B845,$02 #REGhl-=#REGde (with carry).
  $B847,$01 Restore #REGhl from the stack.
  $B848,$03 Jump to #R$B4FC if {} is higher.
  $B84B,$06 Jump to #R$B85F if bit 3 of *#REGix+#N$13 is set.
  $B851,$04 Test bit 4 of *#REGix+#N$13.
  $B855,$02 #REGa=#N$00.
  $B857,$02 Jump to #R$B85B if bit 4 of *#REGix+#N$13 is not set.
  $B859,$02 #REGa=#N$1F.
  $B85B,$01 Reset the bits from #REGl.
  $B85C,$02,b$01 Keep only bits 0-4.
  $B85E,$01 Return if the result is zero.
  $B85F,$01 Stash #REGhl on the stack.
  $B860,$04 Set bit 3 of *#REGix+#N$17.
  $B864,$06 Jump to #R$B886 if bit 1 of *#REGix+#N$17 is not set.
  $B86A,$04 Reset bit 1 of *#REGix+#N$17.
  $B86E,$02 Jump to #R$B881.
  $B870,$01 Stash #REGhl on the stack.
  $B871,$04 Reset bit 3 of *#REGix+#N$17.
  $B875,$05 Call #R$BAAA if bit 6 of #REGb is not set.
  $B87A,$01 Restore #REGhl from the stack.
  $B87B,$01 Stash #REGhl on the stack.
  $B87C,$03 Call #R$B919.
  $B87F,$02 Jump to #R$B889.
  $B881,$03 Call #R$B919.
  $B884,$01 Restore #REGhl from the stack.
  $B885,$01 Stash #REGhl on the stack.
  $B886,$03 Call #R$B99F.
  $B889,$01 Restore #REGhl from the stack.
  $B88A,$02 Set bit 5 of #REGb.
  $B88C,$03 Write #REGb to *#REGix+#N$13.
  $B88F,$03 Write #REGl to *#REGix+#N$10.
  $B892,$03 Write #REGh to *#REGix+#N$11.
  $B895,$04 Jump to #R$B8A6 if bit 3 of #REGb is not set.
  $B899,$03 Increment *#REGix+#N$07 by one.
  $B89C,$04 Jump to #R$B8A6 if bit 4 of #REGb is set.
  $B8A0,$03 Decrease *#REGix+#N$07 by one.
  $B8A3,$03 Decrease *#REGix+#N$07 by one.
  $B8A6,$03 #REGa=*#REGix+#N$13.
  $B8A9,$01 #REGe=#REGa.
  $B8AA,$02 #REGd=#N$00.
  $B8AC,$03 #REGl=*#REGix+#N$14.
  $B8AF,$03 #REGh=*#REGix+#N$15.
  $B8B2,$01 #REGhl+=#REGde.
  $B8B3,$01 #REGa=*#REGhl.
  $B8B4,$03 Write #REGa to *#REGix+#N$0A.
  $B8B7,$01 Increment #REGhl by one.
  $B8B8,$01 #REGa=*#REGhl.
  $B8B9,$03 Write #REGa to *#REGix+#N$0B.
  $B8BC,$01 Increment #REGhl by one.
  $B8BD,$01 #REGa=*#REGhl.
  $B8BE,$03 Write #REGa to *#REGix+#N$0E.
  $B8C1,$01 Increment #REGhl by one.
  $B8C2,$01 #REGa=*#REGhl.
  $B8C3,$03 Write #REGa to *#REGix+#N$0F.
  $B8C6,$01 Increment #REGhl by one.
  $B8C7,$01 #REGe=*#REGhl.
  $B8C8,$01 Increment #REGhl by one.
  $B8C9,$01 #REGd=*#REGhl.
  $B8CA,$03 #REGl=*#REGix+#N$10.
  $B8CD,$03 #REGh=*#REGix+#N$11.
  $B8D0,$01 #REGhl+=#REGde.
  $B8D1,$02 Reset bit 5 of #REGh.
  $B8D3,$03 Write #REGl to *#REGix+#N$0C.
  $B8D6,$03 Write #REGl to *#REGix+#N$08.
  $B8D9,$03 Write #REGh to *#REGix+#N$0D.
  $B8DC,$01 #REGa=#REGh.
  $B8DD,$01 RLCA.
  $B8DE,$01 RLCA.
  $B8DF,$01 RLCA.
  $B8E0,$02,b$01 Keep only bits 3-4.
  $B8E2,$02,b$01 Set bits 6.
  $B8E4,$03 Write #REGa to *#REGix+#N$09.
  $B8E7,$03 #REGa=*#REGix+#N$0A.
  $B8EA,$01 RLCA.
  $B8EB,$01 RLCA.
  $B8EC,$01 RLCA.
  $B8ED,$01 RLCA.
  $B8EE,$03 Write #REGa to *#REGix+#N$16.
  $B8F1,$06 Jump to #R$B8FC if bit 0 of *#REGix+#N$17 is not set.
  $B8F7,$04 Write #N$0B to *#REGix+#N$0B.
  $B8FB,$01 Return.
  $B8FC,$05 Return if bit 2 of *#REGix+#N$17 is not set.
  $B901,$04 Write #N$0B to *#REGix+#N$0B.
  $B905,$03 Increment *#REGix+#N$08 by one.
  $B908,$03 Increment *#REGix+#N$0C by one.
  $B90B,$03 #REGl=*#REGix+#N$0E.
  $B90E,$01 #REGa+=#REGl.
  $B90F,$03 Write #REGa to *#REGix+#N$0E.
  $B912,$01 Return if {} is higher.
  $B913,$03 Increment *#REGix+#N$0F by one.
  $B916,$01 Return.
  $B917,$01 Decrease #REGb by one.
  $B918,$01 Increment #REGc by one.
  $B919,$02 Stash #REGix on the stack.
  $B91B,$04 #REGix=#R$C277.
  $B91F,$01 Stash #REGhl on the stack.
  $B920,$04 Jump to #R$B929 if bit 4 of #REGl is not set.
  $B924,$03 #REGde=#N($000C,$04,$04).
  $B927,$02 #REGix+=#REGde.
  $B929,$03 #REGe=*#REGix+#N$22.
  $B92C,$03 #REGd=*#REGix+#N$23.
  $B92F,$01 Set flags.
  $B930,$02 #REGhl-=#REGde (with carry).
  $B932,$01 Restore #REGhl from the stack.
  $B933,$02 Jump to #R$B948 if {} is zero.
  $B935,$01 #REGa=#REGl.
  $B936,$01 #REGhl+=#REGhl.
  $B937,$01 #REGhl+=#REGhl.
  $B938,$01 #REGhl+=#REGhl.
  $B939,$02,b$01 Keep only bits 0-4.
  $B93B,$01 #REGc=#REGa.
  $B93C,$04 Jump to #R$B96C if #REGa is lower than #N$0A.
  $B940,$04 Jump to #R$B988 if #REGa is higher than #N$16.
  $B944,$03 Restore #REGhl, #REGhl and #REGhl from the stack.
  $B947,$01 Return.
  $B948,$02 Stash #REGix on the stack.
  $B94A,$01 Restore #REGhl from the stack.
  $B94B,$03 #REGde=#N($0021,$04,$04).
  $B94E,$01 #REGhl+=#REGde.
  $B94F,$02 Test bit 4 of *#REGhl.
  $B951,$02 Jump to #R$B944 if {} is zero.
  $B953,$02 Restore #REGix from the stack.
  $B955,$02 Test bit 3 of #REGb.
  $B957,$02 Jump to #R$B945 if {} is zero.
  $B959,$02 Test bit 4 of #REGb.
  $B95B,$02 Jump to #R$B945 if {} is zero.
  $B95D,$02 Test bit 6 of #REGb.
  $B95F,$02 Jump to #R$B945 if {} is zero.
  $B961,$02 Set bit 3 of *#REGhl.
  $B963,$04 Set bit 1 of *#REGix+#N$17.
  $B967,$04 Set bit 0 of *#REGix+#N$18.
  $B96B,$01 Return.
  $B96C,$01 #REGa=#REGh.
  $B96D,$03 Compare #REGa with *#REGix+#N$20.
  $B970,$02 Jump to #R$B944 if {} is not zero.
  $B972,$02 Restore #REGix from the stack.
  $B974,$04 Test bit 1 of *#REGix+#N$17.
  $B978,$01 Return if {} is not zero.
  $B979,$01 #REGa=#REGc.
  $B97A,$02 Compare #REGa with #N$05.
  $B97C,$02 Jump to #R$B983 if {} is higher.
  $B97E,$04 Set bit 0 of *#REGix+#N$17.
  $B982,$01 Return.
  $B983,$04 Set bit 2 of *#REGix+#N$17.
  $B987,$01 Return.
  $B988,$01 #REGa=#REGh.
  $B989,$03 Compare #REGa with *#REGix+#N$20.
  $B98C,$02 Jump to #R$B944 if {} is not zero.
  $B98E,$02 Restore #REGix from the stack.
  $B990,$04 Test bit 1 of *#REGix+#N$17.
  $B994,$01 Return if {} is not zero.
  $B995,$01 #REGa=#REGc.
  $B996,$02 Compare #REGa with #N$1B.
  $B998,$02 Jump to #R$B983 if {} is higher.
  $B99A,$04 Set bit 0 of *#REGix+#N$17.
  $B99E,$01 Return.
  $B99F,$02 Stash #REGix on the stack.
  $B9A1,$04 #REGix=#R$C277.
  $B9A5,$02 Test bit 4 of #REGl.
  $B9A7,$02 Jump to #R$B9AE if {} is zero.
  $B9A9,$03 #REGde=#N($000C,$04,$04).
  $B9AC,$02 #REGix+=#REGde.
  $B9AE,$01 Stash #REGhl on the stack.
  $B9AF,$03 #REGde=#N($0020,$04,$04).
  $B9B2,$01 #REGhl+=#REGde.
  $B9B3,$01 #REGa=*#REGhl.
  $B9B4,$02,b$01 Keep only bits 3-5.
  $B9B6,$02 Compare #REGa with #N$20.
  $B9B8,$01 #REGa=#REGl.
  $B9B9,$02 Jump to #R$B9D7 if {} is not zero.
  $B9BB,$03 #REGe=*#REGix+#N$1E.
  $B9BE,$03 #REGd=*#REGix+#N$1F.
  $B9C1,$01 Restore #REGhl from the stack.
  $B9C2,$01 Stash #REGhl on the stack.
  $B9C3,$01 Set flags.
  $B9C4,$02 #REGhl-=#REGde (with carry).
  $B9C6,$02 Jump to #R$B9D7 if {} is zero.
  $B9C8,$04 Set bit 0 of *#REGix+#N$21.
  $B9CC,$04 Reset bit 1 of *#REGix+#N$21.
  $B9D0,$03 #REGhl=#R$C386.
  $B9D3,$02 Set bit 4 of *#REGhl.
  $B9D5,$02 Jump to #R$B9F6.
  $B9D7,$03 #REGhl=#R$C386.
  $B9DA,$02 Reset bit 4 of *#REGhl.
  $B9DC,$06 Jump to #R$B9F6 if bit 1 of *#REGix+#N$21 is not set.
  $B9E2,$06 Jump to #R$B9F6 if bit 0 of *#REGix+#N$21 is set.
  $B9E8,$02,b$01 Keep only bits 0-4.
  $B9EA,$04 Jump to #R$B9F2 if #REGa is equal to #N$08.
  $B9EE,$04 Jump to #R$B9F6 if #REGa is not equal to #N$17.
  $B9F2,$04 Set bit 2 of *#REGix+#N$21.
  $B9F6,$01 Restore #REGhl from the stack.
  $B9F7,$01 #REGa=#REGl.
  $B9F8,$03 Compare #REGa with *#REGix+#N$1A.
  $B9FB,$02 Jump to #R$BA04 if {} is not zero.
  $B9FD,$01 #REGa=#REGh.
  $B9FE,$03 Compare #REGa with *#REGix+#N$1B.
  $BA01,$02 Jump to #R$BA2C if {} is zero.
  $BA03,$01 #REGa=#REGl.
  $BA04,$03 Compare #REGa with *#REGix+#N$1E.
  $BA07,$02 Jump to #R$BA1D if {} is not zero.
  $BA09,$01 #REGa=#REGh.
  $BA0A,$03 Compare #REGa with *#REGix+#N$1F.
  $BA0D,$02 Jump to #R$BA1D if {} is not zero.
  $BA0F,$02 Restore #REGix from the stack.
  $BA11,$03 Call #R$C144.
  $BA14,$01 Increment #REGhl by one.
  $BA15,$02 Set bit 3 of *#REGhl.
  $BA17,$03 #REGhl=#R$CC3D.
  $BA1A,$02 Set bit 2 of *#REGhl.
  $BA1C,$01 Return.
  $BA1D,$03 #REGl=*#REGix+#N$1E.
  $BA20,$03 #REGh=*#REGix+#N$1F.
  $BA23,$02 Restore #REGix from the stack.
  $BA25,$03 Call #R$C144.
  $BA28,$01 Increment #REGhl by one.
  $BA29,$02 Reset bit 3 of *#REGhl.
  $BA2B,$01 Return.
  $BA2C,$03 Call #R$C144.
  $BA2F,$03 #REGde=#N($0041,$04,$04).
  $BA32,$01 #REGhl+=#REGde.
  $BA33,$04 Jump to #R$BA54 if bit 6 of #REGb is not set.
  $BA37,$02 Reset bit 3 of *#REGhl.
  $BA39,$02 Reset bit 6 of #REGb.
  $BA3B,$04 Set bit 6 of *#REGix+#N$21.
  $BA3F,$04 Test bit 7 of *#REGix+#N$21.
  $BA43,$02 Restore #REGix from the stack.
  $BA45,$03 #REGhl=#R$CC3D.
  $BA48,$02 Jump to #R$BA4D if bit 7 of *#REGix+#N$21 is not set.
  $BA4A,$02 Set bit 3 of *#REGhl.
  $BA4C,$01 Return.
  $BA4D,$02 Set bit 4 of *#REGhl.
  $BA4F,$04 Set bit 4 of *#REGix+#N$17.
  $BA53,$01 Return.
  $BA54,$04 Jump to #R$BAA5 if bit 3 of *#REGhl is set.
  $BA58,$02 Set bit 3 of *#REGhl.
  $BA5A,$02 Set bit 6 of #REGb.
  $BA5C,$04 Reset bit 6 of *#REGix+#N$21.
  $BA60,$06 Jump to #R$BA6E if bit 5 of *#REGix+#N$21 is not set.
  $BA66,$03 #REGa=*#R$C36D.
  $BA69,$02,b$01 Set bits .
  $BA6B,$03 Write #REGa to *#R$C36D.
  $BA6E,$02 Stash #REGix on the stack.
  $BA70,$01 Restore #REGhl from the stack.
  $BA71,$03 #REGde=#N($0021,$04,$04).
  $BA74,$01 #REGhl+=#REGde.
  $BA75,$02 Restore #REGix from the stack.
  $BA77,$04 Test bit 4 of *#REGix+#N$17.
  $BA7B,$04 Reset bit 4 of *#REGix+#N$17.
  $BA7F,$02 Jump to #R$BA9F if bit 4 of *#REGix+#N$17 is set.
  $BA81,$02 Test bit 7 of *#REGhl.
  $BA83,$02 Set bit 7 of *#REGhl.
  $BA85,$02 Jump to #R$BA99 if *#REGhl is set.
  $BA87,$02 Set bit 1 of *#REGhl.
  $BA89,$03 #REGhl=#R$CC3D.
  $BA8C,$02 Set bit 3 of *#REGhl.
  $BA8E,$03 #REGhl=#R$C274.
  $BA91,$02 Stash #REGix on the stack.
  $BA93,$03 Call #R$CB22.
  $BA96,$02 Restore #REGix from the stack.
  $BA98,$01 Return.
  $BA99,$03 #REGhl=#R$CC3D.
  $BA9C,$02 Set bit 3 of *#REGhl.
  $BA9E,$01 Return.
  $BA9F,$03 #REGhl=#R$CC3D.
  $BAA2,$02 Set bit 2 of *#REGhl.
  $BAA4,$01 Return.
  $BAA5,$02 Restore #REGix from the stack.
  $BAA7,$02 Restore #REGhl and #REGhl from the stack.
  $BAA9,$01 Return.
  $BAAA,$03 Return if bit 3 of #REGb is not set.
  $BAAD,$03 Return if bit 4 of #REGb is not set.
  $BAB0,$03 #REGde=#N($0060,$04,$04).
  $BAB3,$02 Reset bit 5 of #REGh.
  $BAB5,$01 Set flags.
  $BAB6,$02 #REGhl-=#REGde (with carry).
  $BAB8,$04 #REGde=*#N$C2CC.
  $BABC,$02 #REGhl-=#REGde (with carry).
  $BABE,$02 Jump to #R$BAC7 if {} is zero.
  $BAC0,$03 #REGde=#N($0001,$04,$04).
  $BAC3,$01 Set flags.
  $BAC4,$02 #REGhl-=#REGde (with carry).
  $BAC6,$01 Return if {} is not zero.
  $BAC7,$02 Restore #REGhl and #REGhl from the stack.
  $BAC9,$02 Set bit 5 of #REGb.
  $BACB,$01 #REGa=#REGb.
  $BACC,$03 Write #REGa to *#REGix+#N$13.
  $BACF,$02,b$01 Keep only bits 3-5.
  $BAD1,$02,b$01 Set bits 7.
  $BAD3,$04 Reset bit 4 of *#REGix+#N$17.
  $BAD7,$03 Call #R$BA9F.
  $BADA,$03 Jump to #R$B8A9.

c $BADD Update Trashman Display
  $BADD,$04 #REGix=#R$C36E.
  $BAE1,$03 #REGb=*#REGix+#N$0A.
  $BAE4,$03 #REGc=*#REGix+#N$0B.
  $BAE7,$03 #REGde=#N($0020,$04,$04).
  $BAEA,$03 #REGl=*#REGix+#N$0C.
  $BAED,$03 #REGh=*#REGix+#N$0D.
  $BAF0,$02 Set bit 5 of #REGh.
  $BAF2,$01 #REGa=#REGl.
  $BAF3,$02,b$01 Keep only bits 0-4.
  $BAF5,$02 Compare #REGa with #N$00.
  $BAF7,$02 Jump to #R$BB06 if {} is lower.
  $BAF9,$02 Compare #REGa with #N$00.
  $BAFB,$02 Jump to #R$BB06 if {} is higher.
  $BAFD,$02 Stash #REGhl and #REGbc on the stack.
  $BAFF,$02 Set bit 6 of *#REGhl.
  $BB01,$01 #REGhl+=#REGde.
  $BB02,$02 Decrease counter by one and loop back to #R$BAFF until counter is zero.
  $BB04,$02 Restore #REGbc and #REGhl from the stack.
  $BB06,$01 Increment #REGhl by one.
  $BB07,$01 Decrease #REGc by one.
  $BB08,$02 Jump to #R$BAF2 if {} is not zero.
  $BB0A,$03 #REGc=*#REGix+#N$0B.
  $BB0D,$03 #REGl=*#REGix+#N$0C.
  $BB10,$03 #REGa=*#REGix+#N$0D.
  $BB13,$03 #REGde=#N($0040,$04,$04).
  $BB16,$02,b$01 Keep only bits 0-1.
  $BB18,$02,b$01 Set bits 3-5.
  $BB1A,$01 #REGh=#REGa.
  $BB1B,$01 #REGhl+=#REGhl.
  $BB1C,$01 Increment #REGhl by one.
  $BB1D,$01 #REGa=#REGl.
  $BB1E,$02,b$01 Keep only bits 0-5.
  $BB20,$02 Compare #REGa with #N$00.
  $BB22,$02 Jump to #R$BB31 if {} is lower.
  $BB24,$02 Compare #REGa with #N$00.
  $BB26,$02 Jump to #R$BB31 if {} is higher.
  $BB28,$02 Stash #REGhl and #REGbc on the stack.
  $BB2A,$02 Reset bit 7 of *#REGhl.
  $BB2C,$01 #REGhl+=#REGde.
  $BB2D,$02 Decrease counter by one and loop back to #R$BB2A until counter is zero.
  $BB2F,$02 Restore #REGbc and #REGhl from the stack.
  $BB31,$01 Increment #REGhl by one.
  $BB32,$01 Decrease #REGc by one.
  $BB33,$02 Jump to #R$BB1C if {} is not zero.
  $BB35,$01 Return.

c $BB36 Initialise Characters
  $BB36,$04 #REGix=#R$C2D4.
  $BB3A,$03 #REGde=#N($000D,$04,$04).
  $BB3D,$02 #REGb=#N$02 (counter).
  $BB3F,$02 #REGa=#N$1F.
  $BB41,$03 Merge the bits of #REGa with *#REGix+#N$05.
  $BB44,$04 Jump to #R$BB4E if #REGa is #N$0A.
  $BB48,$02 #REGix+=#REGde.
  $BB4A,$02 Decrease counter by one and loop back to #R$BB3F until counter is zero.
  $BB4C,$02 #REGa=#N$0B.
  $BB4E,$03 #REGa=#R$BAF5(#N$BAF6).
  $BB51,$01 RLCA.
  $BB52,$03 #REGa=#R$BB20(#N$BB21).
  $BB55,$02 #REGb=#N$02 (counter).
  $BB57,$04 #REGix=#R$C2D4.
  $BB5B,$02 #REGa=#N$1F.
  $BB5D,$03 Merge the bits of #REGa with *#REGix+#N$05.
  $BB60,$04 Jump to #R$BB6A if #REGa is #N$15.
  $BB64,$02 #REGix+=#REGde.
  $BB66,$02 Decrease counter by one and loop back to #R$BB5B until counter is zero.
  $BB68,$02 #REGa=#N$14.
  $BB6A,$01 Increment #REGa by one.
  $BB6B,$03 #REGa=#R$BAF9(#N$BAFA).
  $BB6E,$01 RLCA.
  $BB6F,$03 #REGa=#R$BB24(#N$BB25).
  $BB72,$01 Return.

c $BB73 Trigger Bonus Messaging
  $BB73,$04 #REGix=*#R$C277.
  $BB77,$07 Call #R$BC04 if bit 2 of *#REGix+#N$21 is set.
  $BB7E,$07 Call #R$BBCE if bit 3 of *#REGix+#N$21 is set.
  $BB85,$03 #REGde=#N($000C,$04,$04).
  $BB88,$02 #REGix+=#REGde.
  $BB8A,$07 Call #R$BC04 if bit 2 of *#REGix+#N$21 is set.
  $BB91,$07 Call #R$BBCE if bit 3 of *#REGix+#N$21 is set.
  $BB98,$03 #REGa=*#R$C389.
  $BB9B,$02,b$01 Flip bit 1.
  $BB9D,$02 Test bit 1 of #REGa.
  $BB9F,$03 Write #REGa to *#R$C389.
  $BBA2,$01 Return if bit 1 of #REGa is set.
  $BBA3,$03 #REGhl=#N$C388.
  $BBA6,$01 Decrease *#REGhl by one.
  $BBA7,$02 Jump to #R$BBCB if *#REGhl is not set.
  $BBA9,$02 #REGa=#N$01.
  $BBAB,$02 Return if #REGa is not equal to *#REGhl.
  $BBAD,$03 #REGhl=#R$D811.
  $BBB0,$03 Call #R$BC9E.
  $BBB3,$04 #REGix=#R$C277.
  $BBB7,$04 Set bit 3 of *#REGix+#N$21.
  $BBBB,$03 Call #R$BBCE.
  $BBBE,$03 #REGde=#N($000C,$04,$04).
  $BBC1,$02 #REGix+=#REGde.
  $BBC3,$04 Set bit 3 of *#REGix+#N$21.
  $BBC7,$03 Call #R$BBCE.
  $BBCA,$01 Return.
  $BBCB,$02 Write #N$01 to *#REGhl.
  $BBCD,$01 Return.
  $BBCE,$05 Return if bit 4 of *#REGix+#N$21 is not set.
  $BBD3,$04 Reset bit 4 of *#REGix+#N$21.
  $BBD7,$04 Reset bit 1 of *#REGix+#N$21.
  $BBDB,$03 #REGhl=#R$C389.
  $BBDE,$02 Reset bit 0 of *#REGhl.
  $BBE0,$03 #REGl=*#REGix+#N$22.
  $BBE3,$03 #REGh=*#REGix+#N$23.
  $BBE6,$03 Call #R$C144.
  $BBE9,$01 Increment #REGhl by one.
  $BBEA,$02 Reset bit 3 of *#REGhl.
  $BBEC,$03 #REGde=#N($0040,$04,$04).
  $BBEF,$01 #REGhl+=#REGde.
  $BBF0,$02 Reset bit 3 of *#REGhl.
  $BBF2,$03 #REGhl=#R$C386.
  $BBF5,$03 Return if bit 0 of *#REGhl is not set.
  $BBF8,$03 #REGhl=*#N$C38A.
  $BBFB,$01 #REGa=*#REGhl.
  $BBFC,$03 Write #REGa to *#N$C28F.
  $BBFF,$01 Increment #REGhl by one.
  $BC00,$03 Write #REGhl to *#N$C38A.
  $BC03,$01 Return.
  $BC04,$03 #REGl=*#REGix+#N$22.
  $BC07,$03 #REGh=*#REGix+#N$23.
  $BC0A,$03 Call #R$C144.
  $BC0D,$01 Increment #REGhl by one.
  $BC0E,$02 Set bit 3 of *#REGhl.
  $BC10,$03 #REGde=#N($0040,$04,$04).
  $BC13,$01 #REGhl+=#REGde.
  $BC14,$02 Set bit 3 of *#REGhl.
  $BC16,$04 Set bit 4 of *#REGix+#N$21.
  $BC1A,$03 #REGa=*#R$C386.
  $BC1D,$04 Jump to #R$BC49 if bit 0 of #REGa is set.
  $BC21,$03 #REGhl=#R$C389.
  $BC24,$03 Return if bit 0 of *#REGhl is set.
  $BC27,$02 Set bit 0 of *#REGhl.
  $BC29,$03 #REGl=*#REGix+#N$18.
  $BC2C,$03 #REGh=*#REGix+#N$19.
  $BC2F,$04 #REGhl+=#N($0240,$04,$04).
  $BC33,$01 #REGa=*#REGhl.
  $BC34,$01 Increment #REGhl by one.
  $BC35,$01 #REGh=*#REGhl.
  $BC36,$01 #REGl=#REGa.
  $BC37,$03 #REGa=*#R$C1E5.
  $BC3A,$02,b$01 Keep only bits 3-4.
  $BC3C,$02 #REGd=#N$00.
  $BC3E,$01 #REGe=#REGa.
  $BC3F,$01 #REGhl+=#REGde.
  $BC40,$03 Call #R$BC96.
  $BC43,$03 #REGhl=#R$CC3D.
  $BC46,$02 Set bit 2 of *#REGhl.
  $BC48,$01 Return.
  $BC49,$02 Reset bit 0 of #REGa.
  $BC4B,$03 Write #REGa to *#R$C386.
  $BC4E,$03 #REGl=*#REGix+#N$18.
  $BC51,$03 #REGh=*#REGix+#N$19.
  $BC54,$01 Stash #REGhl on the stack.
  $BC55,$03 #REGde=#N$9C34.
  $BC58,$01 Set flags.
  $BC59,$02 #REGhl-=#REGde (with carry).
  $BC5B,$01 Restore #REGhl from the stack.
  $BC5C,$02 Jump to #R$BC83 if {} is zero.
  $BC5E,$03 #REGde=#N$932E.
  $BC61,$01 Set flags.
  $BC62,$02 #REGhl-=#REGde (with carry).
  $BC64,$02 Jump to #R$BC70 if {} is zero.
  $BC66,$03 #REGhl=*#N$C38A.
  $BC69,$03 Call #R$CB65.
  $BC6C,$03 Call #R$BC96.
  $BC6F,$01 Return.
  $BC70,$03 #REGa=*#R$C1E5.
  $BC73,$04 Jump to #R$BC66 if bit 0 of #REGa is set.
  $BC77,$02 #REGa=#N$64.
  $BC79,$03 Write #REGa to *#R$C291.
  $BC7C,$03 #REGhl=#R$CF1F.
  $BC7F,$03 Call #R$BC9E.
  $BC82,$01 Return.
  $BC83,$03 #REGa=*#R$C1E5.
  $BC86,$04 Jump to #R$BC66 if bit 0 of #REGa is set.
  $BC8A,$05 Write #N$FF to *#R$C292.
  $BC8F,$03 #REGhl=#R$CE17.
  $BC92,$03 Call #R$BC9E.
  $BC95,$01 Return.

c $BC96 Handler: Bonus Messaging
@ $BC96 label=Handler_BonusMessaging
R $BC96 HL Pointer to bonus messaging
N $BC96 Fetch the message string from *#REGhl.
  $BC96,$01 #REGe=*#REGhl.
  $BC97,$01 Increment #REGhl by one.
  $BC98,$01 #REGd=*#REGhl.
  $BC99,$01 Increment #REGhl by one.
  $BC9A,$03 Write #REGhl to *#R$C38A.
  $BC9D,$01 Exchange the #REGde register with the shadow #REGhl register.
@ $BC9E label=Print_BonusMessaging
  $BC9E,$03 #REGde=#N$50C0 (screen buffer location).
  $BCA1,$05 Write #N$00 to *#R$C388.
  $BCA6,$03 Call #R$B081.
  $BCA9,$01 Switch the #REGde and #REGhl registers back to normal.
N $BCAA The messaging appears right at the bottom of the screen. This code blanks out the rest of the two lines to overwrite any existing messaging.
@ $BCAA label=Print_BonusMessaging_Blank
  $BCAA,$02 #REGb=#N$08 (eight lines in a character block).
  $BCAC,$01 Remember where we are on the screen.
N $BCAD Clearing the character block.
@ $BCAD label=Print_BonusMessaging_Loop
  $BCAD,$02 Write #N$00 to *#REGhl.
  $BCAF,$01 Move down one line.
  $BCB0,$02 Decrease counter by one and loop back to #R$BCAD until counter is zero.
  $BCB2,$01 Restore the screen location where we started for this pass (the top of this character block).
  $BCB3,$01 Move right one character block.
N $BCB4 Keep going until the end of the screen is reached.
  $BCB4,$02 Jump to #R$BCAA if #REGl is not zero.
  $BCB6,$01 Return.

c $BCB7 Draw Bonus Sprites
  $BCB7,$04 #REGix=*#R$C277.
  $BCBB,$04
  $BCBF,$04
  $BCC3,$03 Call #R$BCED if bit 2 of *#REGix+#N$21 is set.
  $BCC6,$04
  $BCCA,$04
  $BCCE,$03 Call #R$BCED if bit 3 of *#REGix+#N$21 is set.
  $BCD1,$03 #REGde=#N($000C,$04,$04).
  $BCD4,$02 #REGix+=#REGde.
  $BCD6,$04
  $BCDA,$04
  $BCDE,$03 Call #R$BCED if bit 2 of *#REGix+#N$21 is set.
  $BCE1,$04
  $BCE5,$04
  $BCE9,$03 Call #R$BCED if bit 3 of *#REGix+#N$21 is set.
  $BCEC,$01 Return.

  $BCED,$03 #REGl=*#REGix+#N$22.
  $BCF0,$01 #REGe=#REGl.
  $BCF1,$03 #REGa=*#REGix+#N$23.
  $BCF4,$03 Return if #REGa is #N$00.
  $BCF7,$01 #REGc=#REGa.
  $BCF8,$02,b$01 Keep only bits 0-1.
  $BCFA,$02,b$01 Set bits 3-5.
  $BCFC,$01 #REGh=#REGa.
  $BCFD,$01 #REGhl+=#REGhl.
  $BCFE,$01 #REGa=#REGc.
  $BCFF,$03 #REGbc=#N$0102.
  $BD02,$01 RLCA.
  $BD03,$01 RLCA.
  $BD04,$01 RLCA.
  $BD05,$02,b$01 Keep only bits 3-5.
  $BD07,$02,b$01 Set bit 6.
  $BD09,$01 #REGd=#REGa.
  $BD0A,$03 Jump to #R$B38C.

c $BD0D Update Characters
  $BD0D,$04 #REGix=#R$C2D4.
  $BD11,$02 #REGb=#N$02 (counter).
  $BD13,$01 Stash #REGbc on the stack.
  $BD14,$02 Stash #REGix on the stack.
  $BD16,$03 Call #R$BD24.
  $BD19,$02 Restore #REGix from the stack.
  $BD1B,$05 #REGix+=#N($000D,$04,$04).
  $BD20,$01 Restore #REGbc from the stack.
  $BD21,$02 Decrease counter by one and loop back to #R$BD13 until counter is zero.
  $BD23,$01 Return.

c $BD24 Draw Character
  $BD24,$03 Call #R$C023.
  $BD27,$03 #REGa=*#REGix+#N$00.
  $BD2A,$03 Return if #REGa is higher than #N$17.
  $BD2D,$03 Call #R$C13E.
  $BD30,$03 #REGde=#N($0040,$04,$04).
  $BD33,$03 #REGb=*#REGix+#N$03.
  $BD36,$06 Jump to #R$BD42 if bit 0 of *#REGix+#N$07 is set.
  $BD3C,$02 Reset bit 6 of *#REGhl.
  $BD3E,$01 #REGhl+=#REGde.
  $BD3F,$02 Decrease counter by one and loop back to #R$BD3C until counter is zero.
  $BD41,$01 Return.
  $BD42,$02 Set bit 6 of *#REGhl.
  $BD44,$01 #REGhl+=#REGde.
  $BD45,$02 Decrease counter by one and loop back to #R$BD42 until counter is zero.
  $BD47,$01 Return.

c $BD48 Update Timer Counter
  $BD48,$04 #REGix=#R$C2C7.
  $BD4C,$03 #REGa=*#REGix+#N$07.
  $BD4F,$02,b$01 Reset bits 6.
  $BD51,$02 Test bit 6 of #REGa.
  $BD53,$03 Write #REGa to *#REGix+#N$07.
  $BD56,$01 Return if bit 6 of #REGa is set.
  $BD57,$03 #REGa=*#REGix+#N$00.
  $BD5A,$03 #REGhl=#R$C276.
  $BD5D,$01 #REGa+=*#REGhl.
  $BD5E,$03 #REGhl=#R$C27F.
  $BD61,$03 Jump to #R$BD68 if #REGa is equal to *#REGhl.
  $BD64,$03 Call #R$C023.
  $BD67,$01 Return.
  $BD68,$03 #REGbc=#N($0001,$04,$04).
  $BD6B,$03 #REGhl=*#R$C27D.
  $BD6E,$01 Set flags.
  $BD6F,$02 #REGhl-=#REGbc.
  $BD71,$03 Write #REGhl to *#R$C27D.
  $BD74,$01 Return if {} is not zero.
  $BD75,$03 #REGhl=*#R$C27B.
  $BD78,$03 Write #REGhl to *#R$C27D.
  $BD7B,$03 #REGhl=#R$C279.
  $BD7E,$02 Return if #REGa is higher than *#REGhl.
  $BD80,$03 #REGa=*#R$C27F.
  $BD83,$02 #REGa+=#N$04.
  $BD85,$03 Write #REGa to *#R$C27F.
  $BD88,$01 Return.

c $BD89 Handle Character Collision
  $BD89,$04 #REGix=#R$C356.
  $BD8D,$03 #REGhl=*#R$C277.
  $BD90,$04 Test bit 4 of *#REGix+#N$10.
  $BD94,$03 #REGde=#N($0021,$04,$04).
  $BD97,$02 Jump to #R$BD9C if bit 4 of *#REGix+#N$10 is not set.
  $BD99,$03 #REGde=#N($002D,$04,$04).
  $BD9C,$01 #REGhl+=#REGde.
  $BD9D,$03 Return if bit 5 of *#REGhl is not set.
  $BDA0,$01 #REGa=*#REGhl.
  $BDA1,$03 #REGhl=#R$C35D.
  $BDA4,$03 #REGde=#R$C356.
  $BDA7,$03 #REGbc=#N($0007,$04,$04).
  $BDAA,$02 LDIR.
  $BDAC,$03 #REGhl=#R$C387.
  $BDAF,$01 Decrease *#REGhl by one.
  $BDB0,$01 Return if *#REGhl is not zero.
  $BDB1,$02 Write #N$06 to *#REGhl.
  $BDB3,$04 Jump to #R$BDBC if bit 0 of #REGa is set.
  $BDB7,$05 Return if bit 3 of *#REGix+#N$17 is not set.
  $BDBC,$04 Set bit 3 of *#REGix+#N$17.
  $BDC0,$06 Jump to #R$BDCD if bit 5 of *#REGix+#N$13 is not set.
  $BDC6,$04 Reset bit 5 of *#REGix+#N$13.
  $BDCA,$03 Jump to #R$B8A6.

  $BDCD,$03 #REGa=*#REGix+#N$28.
  $BDD0,$02,b$01 Keep only bits 0-4.
  $BDD2,$06 Jump to #R$BDDE if bit 4 of *#REGix+#N$28 is not set.
  $BDD8,$04 Jump to #R$BE4E if #REGa is lower than #N$16.
  $BDDC,$02 Jump to #R$BDE2.
  $BDDE,$04 Jump to #R$BE4E if #REGa is higher than #N$0A.
  $BDE2,$06 Jump to #R$BE4E if bit 5 of *#REGix+#N$2F is set.
  $BDE8,$03 #REGa=*#REGix+#N$28.
  $BDEB,$01 #REGl=#REGa.
  $BDEC,$02,b$01 Keep only bits 0-4.
  $BDEE,$01 #REGc=#REGa.
  $BDEF,$03 #REGh=*#REGix+#N$29.
  $BDF2,$01 #REGhl+=#REGhl.
  $BDF3,$01 #REGhl+=#REGhl.
  $BDF4,$01 #REGhl+=#REGhl.
  $BDF5,$01 #REGa=#REGh.
  $BDF6,$02,b$01 Keep only bits 0-4.
  $BDF8,$02 NEG.
  $BDFA,$02 #REGa+=#N$15.
  $BDFC,$01 #REGb=#REGa.
  $BDFD,$03 #REGa=*#REGix+#N$10.
  $BE00,$02,b$01 Keep only bits 0-4.
  $BE02,$01 Compare #REGa with #REGc.
  $BE03,$02 #REGc=#N$00.
  $BE05,$02 Jump to #R$BE09 if #REGa is lower than #REGc.
  $BE07,$02 #REGc=#N$10.
  $BE09,$03 #REGa=*#REGix+#N$07.
  $BE0C,$01 Compare #REGa with #REGb.
  $BE0D,$02 #REGb=#N$08.
  $BE0F,$02 Jump to #R$BE13 if #REGa is higher than #REGb.
  $BE11,$02 #REGb=#N$18.
  $BE13,$06 Jump to #R$BE1C if bit 5 of *#REGix+#N$17 is not set.
  $BE19,$01 #REGa=#REGc.
  $BE1A,$01 #REGc=#REGb.
  $BE1B,$01 #REGb=#REGa.
  $BE1C,$06 Jump to #R$BE35 if bit 4 of *#REGix+#N$17 is set.
  $BE22,$03 #REGa=*#REGix+#N$13.
  $BE25,$03 Jump to #R$BE35 if #REGa is equal to #REGc.
  $BE28,$03 Write #REGb to *#REGix+#N$13.
  $BE2B,$03 Call #R$BE75.
  $BE2E,$04 Set bit 4 of *#REGix+#N$17.
  $BE32,$03 Write #REGc to *#REGix+#N$13.
  $BE35,$03 Call #R$BE75.
  $BE38,$04 Reset bit 4 of *#REGix+#N$17.
  $BE3C,$03 Write #REGb to *#REGix+#N$13.
  $BE3F,$03 Call #R$BE75.
  $BE42,$01 #REGa=#REGc.
  $BE43,$02,b$01 Reset bit 4.
  $BE45,$03 Write #REGa to *#REGix+#N$13.
  $BE48,$03 Call #R$BE75.
  $BE4B,$03 Jump to #R$B8A6.
  $BE4E,$05 Return if bit 1 of *#REGix+#N$17 is set.
  $BE53,$04 #REGbc=*#R$B917.
  $BE57,$02 Jump to #R$BDFD.

c $BE59 Handler: Bitten By Dog
@ $BE59 label=Handler_BittenByDog
D $BE59 Checks if Trashman has collided with a dog by comparing their screen
. positions. If they are at the same location, this handler triggers the
. "bitten by dog" sound effect and displays the message "#STR($C221,$03,$20)
. #STR($C241,$03,$08)" to inform the player that a collision has occurred.
R $BE59 IX Pointer to the game state data
N $BE59 Check if Trashman's position matches the dog's position on the street.
  $BE59,$03 Get Trashman's current horizontal position on the street.
  $BE5C,$03 Get Trashman's current vertical position on the street.
  $BE5F,$03 Get the dog's horizontal position on the street.
  $BE62,$03 Get the dog's vertical position on the street.
  $BE65,$03 Compare positions by subtracting the dog's position from Trashman's.
  $BE68,$01 Exit if Trashman and the dog are not at the same location.
@ $BE69 label=Handler_BittenByDog_Trigger
N $BE69 Trashman has been caught by a dog. Trigger the sound effect and display the message.
  $BE69,$05 Set the sound counter to #N$64 frames to play the "bitten by dog" sound.
  $BE6E,$06 Using #R$BC9E print: #UDGTABLE
. { #FONT:(Ouch!  Scat, before I bite  YOUR)$E417,attr=$30(leg-orf-1) }
. { #FONT:(leg orf.)$E417,attr=$30(leg-orf-2) }
. TABLE#
  $BE74,$01 Return.

c $BE75 Update Trashman Position
@ $BE75 label=Trashman_UpdatePosition
D $BE75 Updates Trashman's position on the street based on the player's input direction. This routine
. handles movement calculations, screen boundary checking, collision detection with objects and dogs,
. and manages Trashman's walking animation cycle. The routine ensures Trashman cannot move through
. solid objects or off the edges of the playable area.
R $BE75 IX Pointer to Trashman's data structure containing position, direction, and animation state
N $BE75 Determine which direction Trashman is facing based on his current sprite state.
  $BE75,$04 Clear the "facing right" flag.
  $BE79,$06 Skip setting the flag if Trashman is not moving horizontally.
  $BE7F,$04 Mark that Trashman is facing right.
@ $BE83 label=Trashman_UpdatePosition_LookupOffset
N $BE83 Look up how far Trashman should move in this direction from the movement table. The table
. at #R$C1E7 contains pixel offsets for each of the four possible directions (up, down, left, right).
  $BE83,$03 Point to #R$C1E7.
  $BE86,$02 Prepare to read the movement offset.
  $BE88,$03 Get Trashman's current movement direction.
  $BE8B,$02,b$01 Extract just the direction bits (up/down/left/right).
  $BE8D,$02 Convert direction to table index.
  $BE8F,$01 Store the table index.
  $BE90,$01 Point to the correct entry in the movement table.
  $BE91,$01 Read the horizontal movement offset.
  $BE92,$01 Move to the next byte in the table.
  $BE93,$01 Read the vertical movement offset.
N $BE94 Calculate where Trashman will be after moving. Add the movement offset to his current
. screen position to get the new location.
  $BE94,$03 Get Trashman's current horizontal position on the street.
  $BE97,$03 Get Trashman's current vertical position on the street.
  $BE9A,$01 Move Trashman to his new position by adding the movement offset.
N $BE9B Check if Trashman is trying to move off the edge of the street. The playable area has
. boundaries that prevent Trashman from walking into the gutter or off-screen.
  $BE9B,$06 Skip boundary check if Trashman is moving vertically.
  $BEA1,$01 Get Trashman's horizontal position for boundary checking.
  $BEA2,$06 Check left boundary if Trashman is moving left.
N $BEA8 Trashman has reached the right edge of the street. Stop movement if he's at column 31
. (far right) or column 21 (near right edge of play area).
  $BEA8,$02,b$01 Get just the column number (ignore screen row).
  $BEAA,$06 Stop movement if Trashman has reached the far right edge of the
. street or the right edge of the play area.
  $BEB0,$02 Continue to collision check.
@ $BEB2 label=Trashman_UpdatePosition_CheckLeftBoundary
N $BEB2 Trashman has reached the left edge of the street. Stop movement if he's at column 0
. (far left) or column 10 (near left edge of play area).
  $BEB2,$02,b$01 Get just the column number (ignore screen row).
  $BEB4,$01 Stop movement if Trashman has reached the far left edge of the street.
  $BEB5,$03 Stop movement if Trashman has reached the near left edge of the play area.
@ $BEB8 label=Trashman_UpdatePosition_CheckCollision
N $BEB8 Check if Trashman is trying to walk into a solid object like a bin, barrel, or building.
. If bit 7 of the screen data is set, there's a solid object blocking the way.
  $BEB8,$04 Skip to animation handling if Trashman has hit a solid object.
N $BEBC Update Trashman's facing direction based on his movement. This affects which sprite
. frame is displayed and determines his walking animation sequence.
  $BEBC,$04 Check if Trashman needs to change his facing direction.
  $BEC0,$04 Clear the direction change flag.
  $BEC4,$02 Face up if no direction change is needed.
  $BEC6,$06 Face down if Trashman is moving down the street.
N $BECC Trashman is moving right along the street. Set the direction flags to show he's
. facing and walking to the right.
  $BECC,$04 Clear the "moving up" flag.
  $BED0,$04 Set the "moving right" flag.
  $BED4,$02 Continue to check for dog collision.
@ $BED6 label=Trashman_UpdatePosition_SetMovingDown
N $BED6 Trashman is moving down the street (away from the camera). Set the direction flags
. to show he's walking down the road.
  $BED6,$04 Clear the "moving up" flag.
  $BEDA,$04 Set the "moving down" flag.
  $BEDE,$02 Continue to check for dog collision.
@ $BEE0 label=Trashman_UpdatePosition_SetMovingUp
N $BEE0 Trashman is moving up the street (towards the camera). Set the direction flags to
. show he's walking up the road.
  $BEE0,$04 Clear the "moving down" flag.
  $BEE4,$04 Clear the "moving right" flag.
@ $BEE8 label=Trashman_UpdatePosition_CheckDogCollision
N $BEE8 Check if Trashman has walked into a dog. If he has, trigger the "bitten by dog"
. handler which plays a sound effect and displays a message. Then update Trashman's
. position and animation state.
  $BEE8,$01 Restore the movement offset from the stack.
  $BEE9,$01 Save Trashman's new position on the stack.
  $BEEA,$03 Check if Trashman has collided with a dog at this position.
  $BEED,$03 Point to the sound effects control register.
  $BEF0,$02 Trigger the dog bite sound effect.
  $BEF2,$01 Restore Trashman's position from the stack.
  $BEF3,$03 Get Trashman's movement direction state.
  $BEF6,$03 Update Trashman's position and continue with movement processing.
@ $BEF9 label=Trashman_UpdatePosition_CheckAnimationFrame
N $BEF9 Manage Trashman's walking animation. Adjust the animation frame counter based on
. which direction he's moving to create the walking effect.
  $BEF9,$03 Get the current animation frame counter.
  $BEFC,$06 Use normal animation speed if Trashman is not moving left.
  $BF02,$01 Speed up animation when moving left.
  $BF03,$06 Use normal animation speed if Trashman is not moving right.
  $BF09,$02 Slow down animation when moving right.
@ $BF0B label=Trashman_UpdatePosition_CheckFrameSync
N $BF0B Check if it's time to advance to the next animation frame. When the animation timer
. matches the sprite frame, cycle through the walking animation states to create smooth
. movement animation.
  $BF0B,$04 Don't advance animation if the frame timer hasn't reached the target yet.
  $BF0F,$04 Mark that the animation frame has advanced.
  $BF13,$06 Continue movement if Trashman is already in mid-animation.
  $BF19,$05 Don't change animation if Trashman is moving left.
  $BF1E,$06 Continue to next animation state if Trashman is moving right.
N $BF24 Start the walking animation cycle. This is the first frame where Trashman's legs
. are in the initial position for horizontal movement.
  $BF24,$06 Skip to next animation frame if already in cycle 1.
  $BF2A,$04 Start the first walking animation frame.
  $BF2E,$02 Continue to check for dog collision.
@ $BF30 label=Trashman_UpdatePosition_SetAnimationCycle2
N $BF30 Advance to the second animation frame. Trashman's legs are now in the mid-stride
. position for vertical movement.
  $BF30,$04 Clear the first animation frame flag.
  $BF34,$04 Set the second animation frame flag.
  $BF38,$02 Continue to check for dog collision.
@ $BF3A label=Trashman_UpdatePosition_SetAnimationCycle3
N $BF3A Continue to the third animation frame. Trashman's legs alternate to the opposite
. position for horizontal movement, creating the walking effect.
  $BF3A,$06 Skip to final animation frame if already in cycle 3.
  $BF40,$04 Start the third walking animation frame.
  $BF44,$02 Continue to check for dog collision.
@ $BF46 label=Trashman_UpdatePosition_SetAnimationCycle4
N $BF46 Complete the animation cycle and return to the vertical movement frame. This creates
. a continuous loop of walking animation frames that make Trashman appear to be walking
. along the street.
  $BF46,$04 Clear the third animation frame flag.
  $BF4A,$04 Return to the second animation frame to complete the cycle.
  $BF4E,$02 Continue to check for dog collision.

c $BF50 Check Game Over Conditions
  $BF50,$04 #REGix=#R$C36E.
N $BF54 Check for Game Over "reasons" (see #POKE(immunity,)).
  $BF54,$03 #REGa=*#REGix+#N$17.
  $BF57,$02,b$01 Keep only bits 0-2.
  $BF59,$01 Return if #REGa is not zero.
  $BF5A,$03 #REGl=*#REGix+#N$10.
  $BF5D,$03 #REGh=*#REGix+#N$11.
  $BF60,$03 #REGa=*#REGix+#N$13.
  $BF63,$04 Jump to #R$BF76 if bit 5 of #REGa is not set.
  $BF67,$04 Jump to #R$BF76 if bit 3 of #REGa is set.
  $BF6B,$04 Jump to #R$BF79 if bit 7 of *#REGhl is set.
  $BF6F,$01 Decrease #REGl by one.
  $BF70,$04 Jump to #R$BF76 if bit 4 of #REGa is not set.
  $BF74,$02 Increment #REGl by two.
  $BF76,$03 Return if bit 7 of *#REGhl is not set.
  $BF79,$01 #REGa=#REGl.
  $BF7A,$02,b$01 Keep only bits 0-4.
  $BF7C,$04 Jump to #R$BF8E if #REGa is lower than #N$0C.
  $BF80,$04 Jump to #R$BF8E if #REGa is higher than #N$14.
  $BF84,$01 Restore #REGhl from the stack.
  $BF85,$03 #REGhl=#R$B008.
  $BF88,$02 Set bit 0 of *#REGhl.
  $BF8A,$03 Call #R$BF9F.
  $BF8D,$01 Return.

c $BF8E Handler: Hit By Bike
@ $BF8E label=Handler_HitByBike
D $BF8E Trigger the sound effect and display the message when Trashman is hit
. by a bike.
  $BF8E,$05 Set #R$C290 to #N$50 frames to play the "hit by bike" sound.
  $BF93,$05 Update #R$CC3D to enable the "hit by bike" sound effect.
  $BF98,$06 Using #R$BC9E print: #UDGTABLE
. { #FONT:(Ouch!    Ge'orf the pavement you)$E417,attr=$30(brat-1) }
. { #FONT:(brat.)$E417,attr=$30(brat-2) }
. TABLE#
  $BF9E,$01 Return.

c $BF9F Flash Trashman On Death
  $BF9F,$02 #REGe=#N$42.
  $BFA1,$03 #REGbc=#N($0000,$04,$04).
  $BFA4,$01 Increment #REGb by one.
  $BFA5,$03 Return if bit 4 of #REGb is set.
  $BFA8,$03 Stash #REGbc, #REGde and #REGbc on the stack.
  $BFAB,$04 #REGix=#R$C36E.
  $BFAF,$03 Write #REGe to *#REGix+#N$12.
  $BFB2,$03 Call #R$B416.
  $BFB5,$01 Restore #REGbc from the stack.
  $BFB6,$03 #REGhl=#R$CC3D.
  $BFB9,$03 Call #R$C1CD.
  $BFBC,$03 #REGa=*#R$C1E5.
  $BFBF,$02,b$01 Keep only bits 3-4.
  $BFC1,$01 Set the bits from #REGc.
  $BFC2,$02 OUT #N$FE
  $BFC4,$01 #REGe=#REGb.
  $BFC5,$02 Shift #REGe left (with carry).
  $BFC7,$02 Shift #REGe left (with carry).
  $BFC9,$02 #REGd=#N$00.
  $BFCB,$01 Stash #REGde on the stack.
  $BFCC,$02 Restore #REGix from the stack.
  $BFCE,$03 #REGde=#N$FFFF.
  $BFD1,$02 #REGix+=#REGde.
  $BFD3,$04 Jump to #R$BFDB if bit 7 of *#REGhl is set.
  $BFD7,$02 Jump to #R$BFD1 if {} is lower.
  $BFD9,$02 Jump to #R$BFB9.
  $BFDB,$02 Reset bit 7 of *#REGhl.
  $BFDD,$01 Restore #REGde from the stack.
  $BFDE,$02 Decrease counter by one and loop back to #R$BFA9 until counter is zero.
  $BFE0,$02 #REGa=#N$05.
  $BFE2,$01 Reset the bits from #REGe.
  $BFE3,$01 #REGe=#REGa.
  $BFE4,$01 Restore #REGbc from the stack.
  $BFE5,$02 #REGa=#N$06.
  $BFE7,$01 Reset the bits from #REGc.
  $BFE8,$01 #REGc=#REGa.
  $BFE9,$02 Jump to #R$BFA4.
  $BFEB,$01 Return.

c $BFEC Update Street Objects
@ $BFEC label=Update_StreetObjects
D $BFEC Updates all street objects (bins, barrels, bikes) on the street. This routine processes
. each of the four street objects in three passes: first updating their positions based on
. movement patterns, then handling screen wrapping when objects move off the edges, and
. finally adjusting their positions based on screen wrap settings. This ensures objects
. move smoothly across the street and reappear on the opposite side when they reach an edge.
N $BFEC Process all four street objects to update their positions on the street.
  $BFEC,$04 Point to the first street object in #R$C293.
  $BFF0,$02 Process all four street objects (bins, barrels, bikes).
  $BFF2,$01 Save the loop counter on the stack.
  $BFF3,$03 Update this street object's position based on its movement pattern.
  $BFF6,$05 Move to the next street object (each object takes #N$0D bytes).
  $BFFB,$01 Restore the loop counter from the stack.
  $BFFC,$02 Continue processing the next street object until all four are done.
@ $BFFE label=Update_StreetObjects_Wrapping
N $BFFE Handle screen wrapping for all street objects when they move off the edges.
  $BFFE,$04 Point back to #R$C293.
  $C002,$02 Process all four street objects again.
  $C004,$01 Save the loop counter on the stack.
  $C005,$03 Handle screen wrapping for this object if it has moved off the edge.
  $C008,$05 Move to the next street object (each object takes #N$0D bytes).
  $C00D,$01 Restore the loop counter from the stack.
  $C00E,$02 Continue processing the next street object until all four are done.
@ $C010 label=Update_StreetObjects_Reposition
N $C010 Adjust object positions based on screen wrap settings to ensure smooth transitions.
  $C010,$04 Point back to #R$C293.
  $C014,$02 Process all four street objects one final time.
  $C016,$01 Save the loop counter on the stack.
  $C017,$03 Adjust this object's position based on screen wrap settings.
  $C01A,$05 Move to the next street object (each object takes #N$0D bytes).
  $C01F,$01 Restore the loop counter from the stack.
  $C020,$02 Continue processing the next street object until all four are done.
  $C022,$01 Return.

c $C023 Update Object Position
  $C023,$03 #REGa=*#REGix+#N$07.
  $C026,$04 Jump to #R$C03B if bit 7 of #REGa is not set.
  $C02A,$03 #REGa-=*#REGix+#N$08.
  $C02D,$04 Jump to #R$C042 if bit 3 of #REGa is not set.
  $C031,$02 #REGa+=#N$08.
  $C033,$03 Write #REGa to *#REGix+#N$07.
  $C036,$03 Decrease *#REGix+#N$00 by one.
  $C039,$02 Jump to #R$C057.
  $C03B,$03 #REGa+=*#REGix+#N$08.
  $C03E,$04 Jump to #R$C04F if bit 3 of #REGa is set.
  $C042,$03 Write #REGa to *#REGix+#N$07.
  $C045,$03 #REGa=*#REGix+#N$00.
  $C048,$04 Return if #REGa is higher than *#REGix+#N$0B.
  $C04C,$03 Jump to #R$C112.
  $C04F,$02 Reset bit 3 of #REGa.
  $C051,$03 Write #REGa to *#REGix+#N$07.
  $C054,$03 Increment *#REGix+#N$00 by one.
  $C057,$03 #REGa=*#REGix+#N$00.
  $C05A,$04 Return if #REGa is higher than *#REGix+#N$0B.
  $C05E,$04 Jump to #R$C0A9 if #REGa is higher than #N$14.
  $C062,$05 Jump to #R$C06F if #REGa is lower than *#REGix+#N$0C.
  $C067,$03 #REGa=*#REGix+#N$0C.
  $C06A,$03 Write #REGa to *#REGix+#N$03.
  $C06D,$02 Jump to #R$C073.
  $C06F,$01 Increment #REGa by one.
  $C070,$03 Write #REGa to *#REGix+#N$03.
  $C073,$03 #REGa=*#REGix+#N$05.
  $C076,$02,b$01 Keep only bits 0-4.
  $C078,$01 #REGc=#REGa.
  $C079,$03 #REGa=*#REGix+#N$00.
  $C07C,$02 NEG.
  $C07E,$02 #REGa+=#N$15.
  $C080,$01 #REGe=#REGa.
  $C081,$01 RRCA.
  $C082,$01 RRCA.
  $C083,$01 RRCA.
  $C084,$01 #REGb=#REGa.
  $C085,$02,b$01 Keep only bits 5-7.
  $C087,$01 Set the bits from #REGc.
  $C088,$03 Write #REGa to *#REGix+#N$05.
  $C08B,$03 Write #REGa to *#REGix+#N$01.
  $C08E,$02 #REGa=#N$03.
  $C090,$01 Merge the bits from #REGb.
  $C091,$02,b$01 Set bits 3-4, 6.
  $C093,$01 #REGd=#REGa.
  $C094,$02 Set bit 5 of #REGd.
  $C096,$03 Write #REGa to *#REGix+#N$06.
  $C099,$02 #REGa=#N$18.
  $C09B,$01 Merge the bits from #REGe.
  $C09C,$02,b$01 Set bits 6.
  $C09E,$03 Write #REGa to *#REGix+#N$02.
  $C0A1,$03 #REGe=*#REGix+#N$05.
  $C0A4,$03 #REGbc=#N($0000,$04,$04).
  $C0A7,$02 Jump to #R$C0D8.
  $C0A9,$02 NEG.
  $C0AB,$03 #REGa+=*#REGix+#N$0B.
  $C0AE,$03 Write #REGa to *#REGix+#N$03.
  $C0B1,$03 #REGa-=*#REGix+#N$0C.
  $C0B4,$02 NEG.
  $C0B6,$06 Jump to #R$C0BD if bit 0 of *#REGix+#N$04 is set.
  $C0BC,$01 RLCA.
  $C0BD,$01 #REGc=#REGa.
  $C0BE,$02 #REGb=#N$00.
  $C0C0,$03 #REGa=*#REGix+#N$05.
  $C0C3,$02,b$01 Keep only bits 0-4.
  $C0C5,$02,b$01 Set bits 6.
  $C0C7,$01 #REGe=#REGa.
  $C0C8,$03 Write #REGa to *#REGix+#N$05.
  $C0CB,$03 Write #REGa to *#REGix+#N$01.
  $C0CE,$02 #REGd=#N$78.
  $C0D0,$04 Write #N$06 to *#REGix+#N$06.
  $C0D4,$04 Write #N$02 to *#REGix+#N$02.
  $C0D8,$03 #REGl=*#REGix+#N$09.
  $C0DB,$03 #REGh=*#REGix+#N$0A.
  $C0DE,$01 #REGa=#REGc.
  $C0DF,$02 Stash #REGaf and #REGhl on the stack.
  $C0E1,$01 #REGhl+=#REGbc.
  $C0E2,$03 #REGc=*#REGix+#N$0C.
  $C0E5,$06 Jump to #R$C0ED if bit 0 of *#REGix+#N$04 is set.
  $C0EB,$02 Shift #REGc left (with carry).
  $C0ED,$02 Shift #REGc left (with carry).
  $C0EF,$01 #REGhl+=#REGbc.
  $C0F0,$03 #REGb=*#REGix+#N$03.
  $C0F3,$03 #REGc=*#REGix+#N$04.
  $C0F6,$02 Stash #REGbc and #REGde on the stack.
  $C0F8,$03 Call #R$B1B2.
  $C0FB,$01 Restore #REGhl from the stack.
  $C0FC,$01 #REGhl+=#REGhl.
  $C0FD,$02 #REGa=#N$07.
  $C0FF,$01 Merge the bits from #REGh.
  $C100,$02,b$01 Set bits 4-6.
  $C102,$01 #REGd=#REGa.
  $C103,$01 #REGe=#REGl.
  $C104,$03 Restore #REGbc, #REGhl and #REGaf from the stack.
  $C107,$01 RLCA.
  $C108,$01 #REGa+=#REGl.
  $C109,$01 #REGl=#REGa.
  $C10A,$02 Jump to #R$C10D if {} is higher.
  $C10C,$01 Increment #REGh by one.
  $C10D,$02 Shift #REGc left (with carry).
  $C10F,$03 Call #R$B293.
  $C112,$03 Call #R$C13E.
  $C115,$03 #REGb=*#REGix+#N$03.
  $C118,$03 #REGa=*#REGix+#N$07.
  $C11B,$02,b$01 Keep only bits 0-2.
  $C11D,$01 #REGc=#REGa.
  $C11E,$03 #REGde=#N($003D,$04,$04).
  $C121,$01 #REGa=*#REGhl.
  $C122,$02,b$01 Keep only bits 3-7.
  $C124,$01 Set the bits from #REGc.
  $C125,$01 Write #REGa to *#REGhl.
  $C126,$01 Increment #REGl by one.
  $C127,$02 Set bit 7 of *#REGhl.
  $C129,$02 Increment #REGl by two.
  $C12B,$06 Jump to #R$C13A if bit 0 of *#REGix+#N$04 is set.
  $C131,$01 Decrease #REGl by one.
  $C132,$01 #REGa=*#REGhl.
  $C133,$02,b$01 Keep only bits 3-7.
  $C135,$01 Set the bits from #REGc.
  $C136,$01 Write #REGa to *#REGhl.
  $C137,$01 Increment #REGl by one.
  $C138,$02 Set bit 7 of *#REGhl.
  $C13A,$01 #REGhl+=#REGde.
  $C13B,$02 Decrease counter by one and loop back to #R$C121 until counter is zero.
  $C13D,$01 Return.

c $C13E Calculate Screen Address
  $C13E,$03 #REGh=*#REGix+#N$06.
  $C141,$03 #REGl=*#REGix+#N$05.
  $C144,$01 #REGhl*=#N$02.
  $C145,$02 #REGa=#N$07.
  $C147,$01 Merge the bits from #REGh.
  $C148,$02,b$01 Set bits 4-6.
  $C14A,$01 #REGh=#REGa.
  $C14B,$01 Return.

c $C14C Handle Object Wrapping
  $C14C,$04 Test bit 7 of *#REGix+#N$07.
  $C150,$03 #REGhl=#R$C38C.
  $C153,$02 Jump to #R$C15A if bit 7 of *#REGix+#N$07 is set.
  $C155,$02 #REGa=#N$20.
  $C157,$01 #REGc=*#REGhl.
  $C158,$02 Jump to #R$C15D.
  $C15A,$01 #REGa=*#REGhl.
  $C15B,$02 #REGc=#N$20.
  $C15D,$04 Return if #REGa is not equal to *#REGix+#N$00.
  $C161,$03 Write #REGc to *#REGix+#N$00.
  $C164,$02 Stash #REGix on the stack.
  $C166,$03 Call #R$C1CD.
  $C169,$02 Restore #REGix from the stack.
  $C16B,$03 #REGa=*#R$C1E5.
  $C16E,$02,b$01 Keep only bits 0-1.
  $C170,$02 Jump to #R$C174 if #REGa is not zero.
  $C172,$02 #REGa+=#N$02.
  $C174,$03 Write #REGa to *#REGix+#N$08.
  $C177,$01 Return.
  $C178,$03 #REGhl=#R$C38C.
  $C17B,$01 #REGa=*#REGhl.
  $C17C,$02 #REGa-=#N$20.
  $C17E,$01 #REGb=#REGa.
  $C17F,$03 #REGa=*#REGix+#N$00.
  $C182,$06 Jump to #R$C196 if bit 7 of *#REGix+#N$07 is not set.
  $C188,$02 #REGa-=#N$06.
  $C18A,$04 Jump to #R$C1A0 if #REGa is lower than #N$20.
  $C18E,$01 Compare #REGa with *#REGhl.
  $C18F,$02 Jump to #R$C193 if {} is zero.
  $C191,$02 Jump to #R$C1A0 if {} is higher.
  $C193,$01 #REGa-=#REGb.
  $C194,$02 Jump to #R$C1A0.
  $C196,$02 #REGa+=#N$06.
  $C198,$04 Jump to #R$C1A0 if #REGa is lower than #N$20.
  $C19C,$03 Jump to #R$C1A0 if #REGa is higher than *#REGhl.
  $C19F,$01 #REGa+=#REGb.
  $C1A0,$03 #REGl=*#REGix+#N$01.
  $C1A3,$02 Stash #REGix on the stack.
  $C1A5,$04 #REGix=#R$C293.
  $C1A9,$02 #REGb=#N$04 (counter).
  $C1AB,$03 #REGde=#N($000D,$04,$04).
  $C1AE,$05 Jump to #R$C1BA if #REGa with *#REGix+#N$00 is zero.
  $C1B3,$02 #REGix+=#REGde.
  $C1B5,$02 Decrease counter by one and loop back to #R$C1AE until counter is zero.
  $C1B7,$02 Restore #REGix from the stack.
  $C1B9,$01 Return.
  $C1BA,$01 #REGc=#REGa.
  $C1BB,$03 #REGa=*#REGix+#N$01.
  $C1BE,$01 Reset the bits from #REGl.
  $C1BF,$02,b$01 Keep only bits 0-4.
  $C1C1,$01 #REGa=#REGc.
  $C1C2,$02 Jump to #R$C1B3 if {} is not zero.
  $C1C4,$03 #REGa=*#REGix+#N$08.
  $C1C7,$02 Restore #REGix from the stack.
  $C1C9,$03 Write #REGa to *#REGix+#N$08.
  $C1CC,$01 Return.
  $C1CD,$04 #REGix=#R$C1E5.
  $C1D1,$04 Rotate *#REGix+#N$01 right.
  $C1D5,$06 Jump to #R$C1DC if bit 4 of *#REGix+#N$00 is zero.
  $C1DB,$01 Invert the carry flag.
  $C1DC,$04 Rotate *#REGix+#N$00 left.
  $C1E0,$04 Rotate *#REGix+#N$01 left.
  $C1E4,$01 Return.

g $C1E5
B $C1E5

g $C1E7 Movement Offsets
@ $C1E7 label=MovementOffsets
B $C1E7,$08

t $C1EF Messaging: Bonus
@ $C1EF label=Messaging_Bonus
  $C1EF,$06,$05:$01 #FONT$E417,attr=$30,chars=0(Bonus)(bonus)

t $C1F5 Messaging: Score
@ $C1F5 label=Messaging_Score
  $C1F5,$06,$05:$01 #FONT$E417,attr=$30,chars=0(Score)(score)

t $C1FB Messaging: You have not collected all the bins
@ $C1FB label=Messaging_NotAllTheBins
  $C1FB,$26,$20,$05:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(You have not collected  all  the)(all-the-bins-1) }
. { #FONT$E417,attr=$30,chars=0(bins.)(all-the-bins-2) }
. TABLE#

t $C221 Messaging: Ouch! Scat, before I bite YOUR leg orf
@ $C221 label=Messaging_LegOrf
  $C221,$29,$20,$08:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Ouch!  Scat, before I bite  YOUR)(leg-orf-1) }
. { #FONT$E417,attr=$30,chars=0(leg orf.)(leg-orf-2) }
. TABLE#

t $C24A Messaging: Ouch! Ge'orf the pavement youbrat
@ $C24A label=Messaging_Brat
  $C24A,$26,$20,$05:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Ouch!    Ge'orf the pavement you)(brat-1) }
. { #FONT$E417,attr=$30,chars=0(brat.)(brat-2) }
. TABLE#

g $C270 Number Of Bins String
@ $C270 label=String_NumberOfBins
D $C270 Points to the string which contains the number of bins to collect for the current street.
. #TABLE(default,centre) { #R$B01E } { #R$B023 } { #R$B027 } { #R$B02D } { #R$B033 } { #R$B038 } { #R$B03C } TABLE#
W $C270,$02

g $C272 Time Remaining
@ $C272 label=Time_Remaining
D $C272 Time Remaining equates to how much bonus the player receives when the level is completed. Stored as e.g.
.
. #TABLE(default,centre,centre)
. { =h Location | =h Value }
. { #R$C272(#N$C272) | #N$50 }
. { #R$C273(#N$C273) | #N$02 }
. TABLE#
.
. For "250" seconds/ bonus points remaining.
N $C272 See #POKE(timeLeft,).
B $C272,$02,$01

g $C274 Scroll Counter

g $C276 Timer

g $C277 Playarea Pointer
W $C277,$02

g $C279 Scroll Threshold
g $C27A Scroll Speed
g $C27B Timer Reset Value

g $C27D Timer Counter
W $C27D,$02

g $C27F Timer Threshold

t $C280 Messaging: Road Name
@ $C280 label=Messaging_RoadName
  $C280,$0E,$0D:$01

g $C28E Scroll Direction

g $C290 Sound Counter
@ $C290 label=SoundCounter
B $C290,$01

g $C291 Bonus Flash Counter

g $C292 Bonus Display Flag

g $C293 Table: Street Objects
@ $C293 label=Table_StreetObjects
N $C293 Object #N($01+(#PC-$C293)/$0D).
B $C293,$0D
L $C293,$0D,$07

g $C2EE Table: Bonus Sprites
@ $C2EE label=Table_BonusSprites
N $C2EE Object #N($01+(#PC-$C2EE)/$0D).
B $C2EE,$0D
L $C2EE,$0D,$08

g $C356 Secondary Character Data

g $C35D Secondary Character Backup

g $C36E Player Data
@ $C36E label=Player_Data
B $C36E,$01
@ $C36F label=Player_ScreenXPosition
B $C36F,$01
@ $C370 label=Player_ScreenYPosition
B $C370,$01
@ $C371 label=Player_SpriteHeight
B $C371,$01
@ $C372 label=Player_SpriteWidth
B $C372,$01
@ $C373 label=Player_SpriteGraphics
B $C373,$02
B $C375,$01
@ $C376 label=Player_ScreenBuffer
B $C376,$02
@ $C386 label=Player_
B $C386,$01

g $C387 Character Animation Counter
g $C388 Bonus Message Timer
g $C389 Sound Flags

g $C38A Bonus Messaging
@ $C38A label=BonusMessaging
W $C38A,$02

g $C38C Screen Wrapping Left
g $C38D Screen Wrapping Right

c $CAB3 Print Numbers
@ $CAB3 label=PrintNumbers
R $CAB3 B Number of characters to print
R $CAB3 DE Screen buffer pointer
R $CAB3 HL Pointer to end of number string data
  $CAB3,$02 #REGa=#N$00.
  $CAB5,$02 Extract the first digit into #REGa.
  $CAB7,$01 Stash the result on the stack.
  $CAB8,$04 Jump to #R$CADA if #REGa is not #N$00.
N $CABC The highest digit is zero, so instead of printing an ASCII zero, print an ASCII space character instead.
  $CABC,$02 #REGa=ASCII "space" character (#N$20).
  $CABE,$03 Call #R$CAEF.
N $CAC1 Move onto the next digit extraction.
  $CAC1,$01 Restore #REGaf from the stack.
  $CAC2,$02 Extract the next digit into #REGa.
  $CAC4,$01 Stash the result on the stack.
  $CAC5,$04 Jump to #R$CAE3 if #REGa is not #N$00.
N $CAC9 The next digit is also zero, so again print an ASCII space character.
  $CAC9,$02 #REGa=ASCII "space" character (#N$20).
  $CACB,$03 Call #R$CAEF.
N $CACE Housekeeping, and loop control.
  $CACE,$01 Restore #REGaf from the stack.
  $CACF,$02 Restore the original byte value back to *#REGhl.
  $CAD1,$01 Decrease the string pointer by one - move to the next number character.
  $CAD2,$02 Decrease the length counter by one and loop back to #R$CAB3 until the counter is zero.
  $CAD4,$01 Return.
N $CAD5 Note; the above doesn't jump straight to this, as it's already processing the first RLD result.
@ $CAD5 label=PrintNumbers_Loop
  $CAD5,$02 #REGa=#N$00.
  $CAD7,$02 Extract the first digit into #REGa.
  $CAD9,$01 Stash the result on the stack.
@ $CADA label=PrintNumbers_BigNumber
  $CADA,$02 #REGa contains the number character to be printed - add ASCII zero to it (#N$30).
  $CADC,$03 Call #R$CAEF.
  $CADF,$01 Restore #REGaf from the stack.
  $CAE0,$02 Extract the next digit into #REGa.
  $CAE2,$01 Stash the result on the stack.
@ $CAE3 label=PrintNumbers_LittleNumber
  $CAE3,$02 #REGa contains the number character to be printed - add ASCII zero to it (#N$30).
  $CAE5,$03 Call #R$CAEF.
  $CAE8,$01 Restore #REGaf from the stack.
  $CAE9,$02 Restore the original byte value back to *#REGhl.
  $CAEB,$01 Decrease the string pointer by one - move to the next number character.
  $CAEC,$02 Decrease the length counter by one and loop back to #R$CAD5 until the counter is zero.
  $CAEE,$01 Return.
N $CAEF This is similar in functionality to #R$B081.
.       It differs as it doesn't use a terminator rather the length is known.
@ $CAEF label=PrintNumbers_Print
  $CAEF,$02 Stash pointer to the string and the length counter on the stack.
N $CAF1 Create an offset in #REGhl using #REGa - which contains the number value we want to print.
  $CAF1,$01 #REGl=#REGa.
  $CAF2,$02 #REGh=#N$00.
  $CAF4,$03 #REGhl*=#N$08.
M $CAF1,$06 #REGhl=#REGa*$08 (as each font character is made up of 8 bytes).
  $CAF7,$03 #REGbc=#R$E417.
  $CAFA,$01 Decrease #REGb by one.
  $CAFB,$01 #REGhl+=#REGbc.
  $CAFC,$01 Stash the current screen buffer pointer on the stack.
  $CAFD,$02 #REGb=#N$08 (because each font character is 8 bytes).
@ $CAFF label=PrintNumbers_Print_Loop
  $CAFF,$01 Fetch a byte from the custom font.
  $CB00,$01 Write the byte to the screen buffer.
  $CB01,$01 Move onto the next byte of the custom font.
  $CB02,$01 Adjust the screen buffer position down one row.
  $CB03,$02 Decrease the byte counter by one and loop back to #R$CAFF until the counter is zero
.           (all 8 bytes have been copied to the screen buffer).
  $CB05,$01 Restore the original screen buffer pointer from the stack.
  $CB06,$01 Move the screen buffer pointer right one character block ready for printing the next character.
  $CB07,$02 Restore the length counter and pointer to the string from the stack.
  $CB09,$01 Return.

c $CB0A Print Bonus/ Score
@ $CB0A label=Print_Bonus
N $CB0A Print the current "Bonus" value.
  $CB0A,$02 #REGb=#N$02 (number of characters stored for #R$C272).
  $CB0C,$03 #REGde=#N$403B (screen buffer location).
N $CB0F Work backwards - the data is stored back-to-front e.g. #N$50,#N$02 for outputting "250".
  $CB0F,$03 #REGhl=#R$C272.
  $CB12,$01 Increment #REGhl by one.
  $CB13,$03 Call #R$CAB3.
N $CB16 Print the current score.
  $CB16,$03 #REGde=#N$4020 (screen buffer location).
@ $CB19 label=Print_Score
  $CB19,$02 #REGb=#N$03 (number of characters in the players score).
  $CB1B,$03 #REGhl=#R$CB98 (last digit of #R$CB96).
  $CB1E,$03 Call #R$CAB3.
  $CB21,$01 Return.

c $CB22 Add Points To Score
@ $CB22 label=AddPointsToScore
R $CB22 HL Pointer to address of points to add to score
N $CB22 An example of #REGhl is #R$C272 which would add the time remaining to the score when the level is complete.
  $CB22,$04 #REGix=#R$CB96.
N $CB26 Handle the "tens" units.
  $CB26,$03 #REGa=*#REGix+#N$00.
  $CB29,$02 Add *#REGhl to score byte #1 with BCD conversion.
  $CB2B,$03 Write #REGa to *#REGix+#N$00.
N $CB2E Move onto the next score digit.
  $CB2E,$01 Increment #REGhl by one.
N $CB2F Handle the "thousands" units.
  $CB2F,$03 #REGa=*#REGix+#N$01.
  $CB32,$02 Add (with carry) *#REGhl to score byte #2 with BCD conversion.
N $CB34 Handle the "hundreds of thousands" units.
  $CB34,$03 Write #REGa to *#REGix+#N$01.
N $CB37 The final digit always has a base of #N$00.
  $CB37,$05 Add (with carry) #N$00 to *#REGix+#N$02 to score byte #3.
  $CB3C,$03 Write #REGa to *#REGix+#N$02.
  $CB3F,$01 Return.

c $CB40 Handler: Time
@ $CB40 label=Handler_Time
  $CB40,$03 #REGhl=#R$C272.
N $CB43 Fetch the small unit of time (e.g. for "250" this is "50").
  $CB43,$01 #REGa=*#REGhl.
N $CB44 Take off one unit of time (see #POKE(infinite_time,)).
  $CB44,$03 #REGa-=#N$01 with BCD conversion.
  $CB47,$01 Write #REGa to *#REGhl.
  $CB48,$01 Return if #REGa is higher than #N$00.
N $CB49 We've ticked over the small unit, so move onto the larger unit.
  $CB49,$01 Increment #REGhl by one.
N $CB4A Fetch the large unit of time (e.g. for "250" this is "2").
  $CB4A,$01 #REGa=*#REGhl.
N $CB4B Take off one unit of time.
  $CB4B,$03 #REGa-=#N$01 with BCD conversion.
  $CB4E,$01 Write #REGa to *#REGhl.
  $CB4F,$02 Jump to #R$CB5C if #REGa is not zero.
N $CB51 Flash the bonus/ time countdown when the large unit is zero.
  $CB51,$03 #REGhl=#N$583B (attribute buffer address for the bonus/ time counter).
  $CB54,$02 #REGb=#N$04 (counter).
@ $CB56 label=Handler_Time_Flash
  $CB56,$02 Set bit 7 (the flash bit) of *#REGhl.
  $CB58,$01 Increment #REGl by one.
  $CB59,$02 Decrease counter by one and loop back to #R$CB56 until counter is zero.
  $CB5B,$01 Return.
N $CB5C Is there any time left?
@ $CB5C label=Handler_Time_Up
  $CB5C,$01 Return if #REGa is higher than #N$00 (if there is still time left).
N $CB5D There's no time left, signify the game is over.
  $CB5D,$02 Clear the stack.
  $CB5F,$03 #REGhl=#R$B008.
  $CB62,$02 Set bit 2 of *#REGhl.
  $CB64,$01 Return.

c $CB65 Add To Bonus Counter
  $CB65,$02 Stash #REGix on the stack.
  $CB67,$04 #REGix=#R$C272.
  $CB6B,$03 #REGa=*#REGix+#N$00.
  $CB6E,$01 #REGa+=*#REGhl.
  $CB6F,$01 DAA.
  $CB70,$03 Write #REGa to *#REGix+#N$00.
  $CB73,$01 Increment #REGhl by one.
  $CB74,$03 #REGa=*#REGix+#N$01.
  $CB77,$01 #REGa+=*#REGhl.
  $CB78,$01 DAA.
  $CB79,$03 Write #REGa to *#REGix+#N$01.
  $CB7C,$01 Increment #REGhl by one.
  $CB7D,$02 Jump to #R$CB93 if {} is zero.
  $CB7F,$04 #REGix=#N$583B.
  $CB83,$04 Reset bit 7 of *#REGix+#N$00.
  $CB87,$04 Reset bit 7 of *#REGix+#N$01.
  $CB8B,$04 Reset bit 7 of *#REGix+#N$02.
  $CB8F,$04 Reset bit 7 of *#REGix+#N$03.
  $CB93,$02 Restore #REGix from the stack.
  $CB95,$01 Return.

g $CB96 Active Players Score
@ $CB96 label=ActivePlayer_Score
D $CB96 The current players score for display. Stored as e.g.
.
. #TABLE(default,centre,centre)
. { =h Location | =h Value }
. { #R$CB96(#N$CB96) | #N$33 }
. { #R$CB97(#N$CB97) | #N$22 }
. { #R$CB98(#N$CB98) | #N$11 }
. TABLE#
.
. For a score of "112233" points.
B $CB96,$03,$01

g $CB99 Inactive Players Score
@ $CB99 label=InactivePlayer_Score
D $CB99 See #R$CB96 for explanation.
B $CB99,$03,$01

c $CB9C Handle Sound Effects
  $CB9C,$03 #REGhl=#R$CC3D.
  $CB9F,$02 Reset bit 7 of *#REGhl.
  $CBA1,$01 #REGa=*#REGhl.
  $CBA2,$01 Rotate #REGa right one bit (with carry).
  $CBA3,$02 Jump to #R$CBD0 if the carry bit was set.
  $CBA5,$01 Rotate #REGa right one bit (with carry).
  $CBA6,$02 Jump to #R$CBFB if the carry bit was set.
  $CBA8,$01 Rotate #REGa right one bit (with carry).
  $CBA9,$02 Jump to #R$CC0B if the carry bit was set.
  $CBAB,$01 Rotate #REGa right one bit (with carry).
  $CBAC,$02 Jump to #R$CBBC if the carry bit was set.
  $CBAE,$01 Rotate #REGa right one bit (with carry).
  $CBAF,$02 Jump to #R$CBC7 if the carry bit was set.
  $CBB1,$01 Rotate #REGa right one bit (with carry).
  $CBB2,$02 Jump to #R$CBF2 if the carry bit was set.
  $CBB4,$04 Set border to YELLOW.
  $CBB8,$01 Halt operation (suspend CPU until the next interrupt).
  $CBB9,$02 Reset bit 7 of *#REGhl.
  $CBBB,$01 Return.

  $CBBC,$03 #REGde=#N($0070,$04,$04).
  $CBBF,$04 Write #REGde to *#R$CC3B.
  $CBC3,$02 Reset bit 3 of *#REGhl.
  $CBC5,$02 Jump to #R$CBD0.
  $CBC7,$03 #REGde=#N($0100,$04,$04).
  $CBCA,$04 Write #REGde to *#R$CC3B.
  $CBCE,$02 Reset bit 4 of *#REGhl.
  $CBD0,$02 Reset bit 0 of *#REGhl.
  $CBD2,$02 #REGa=#N$06.
  $CBD4,$03 #REGde=#N$FFFF.
  $CBD7,$04 #REGix=#R$CC3B.
  $CBDB,$02 #REGix+=#REGde.
  $CBDD,$02 Jump to #R$CBE5 if {} is higher.
  $CBDF,$04 Jump to #R$CBEF if bit 7 of *#REGhl is not zero.
  $CBE3,$02 Jump to #R$CBDB.
  $CBE5,$04 Jump to #R$CBEF if bit 7 of *#REGhl is not zero.
  $CBE9,$02,b$01 XOR bits 3-4 (if they are set, unset them and if they are unset, set them).
  $CBEB,$02 OUT #N$FE
  $CBED,$02 Jump to #R$CBD7.
  $CBEF,$02 Reset bit 7 of *#REGhl.
  $CBF1,$01 Return.
  $CBF2,$02 Reset bit 5 of *#REGhl.
  $CBF4,$02 #REGc=#N$00.
  $CBF6,$03 #REGde=#N($0040,$04,$04).
  $CBF9,$02 Jump to #R$CC12.
  $CBFB,$02 Reset bit 1 of *#REGhl.
  $CBFD,$03 Call #R$C1CD.
  $CC00,$06 Jump to #R$CBA8 if bit 0 of *#REGix+#N$00 is not zero.
  $CC06,$03 #REGde=#N($0020,$04,$04).
  $CC09,$02 Jump to #R$CC10.
  $CC0B,$02 Reset bit 2 of *#REGhl.
  $CC0D,$03 #REGde=#N($0060,$04,$04).
  $CC10,$02 #REGc=#N$06.
  $CC12,$04 Write #REGde to *#R$CC3B.
  $CC16,$03 #REGde=#N$FFFF.
  $CC19,$04 #REGix=#R$CC3B.
  $CC1D,$02 #REGix+=#REGde.
  $CC1F,$02 Jump to #R$CC27 if {} is higher.
  $CC21,$04 Jump to #R$CC38 if bit 7 of *#REGhl is not zero.
  $CC25,$02 Jump to #R$CC1D.
  $CC27,$04 Jump to #R$CC38 if bit 7 of *#REGhl is not zero.
  $CC2B,$03 Call #R$C1CD.
  $CC2E,$03 #REGa=*#R$C1E5.
  $CC31,$02,b$01 Keep only bits 3-4.
  $CC33,$01 Set the bits from #REGc.
  $CC34,$02 OUT #N$FE
  $CC36,$02 Jump to #R$CC19.
  $CC38,$02 Reset bit 7 of *#REGhl.
  $CC3A,$01 Return.
W $CC3B,$02

g $CC3D Sound Effect
@ $CC3D label=SoundEffect
D $CC3D #TABLE(default,centre,centre)
.   { =h Bit | =h Sound Effect }
.   { #N$00 |  }
.   { #N$01 |  }
.   { #N$02 |  }
.   { #N$03 |  }
.   { #N$04 |  }
.   { #N$05 | Hit By Bike }
.   { #N$06 |  }
.   { #N$07 |  }
. TABLE#
B $CC3D,$01

b $CC3E Table: In-Game Messaging
@ $CC3E label=Table_InGameMessaging
W $CC3E,$02 "#D(#PEEK(#PC) + #PEEK(#PC + $01) * $100)".
  $CC40,$01
W $CC41,$02 Points.
W $CC43,$02 "#D(#PEEK(#PC) + #PEEK(#PC + $01) * $100)".
  $CC45,$01
L $CC3E,$08,$20

t $CD3E Messaging: One For The Road?
@ $CD3E label=Messaging_OneForTheRoad
  $CD3E,$18,$17:$01 #FONT$E417,attr=$30,chars=0(One for the road? (250))(one-for-the-road)

t $CD56 Messaging: You're Supposed To Empty The Bin
@ $CD56 label=Messaging_SupposedToEmptyTheBin
  $CD56,$30,$20,$0F:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(You're supposed to empty the bin)(empty-the-bin-1) }
. { #FONT$E417,attr=$30,chars=0(not the barrel.)(empty-the-bin-2) }
. TABLE#

t $CD86 Messaging: Come In For A Quick Pint
@ $CD86 label=Messaging_QuickPint
  $CD86,$20,$1F:$01 #FONT$E417,attr=$30,chars=0(Come in for a quick pint. (230))(quick-pint)

t $CDA6 Messaging: Well, milk's better for you
  $CDA6,$1D,$1C:$01 #FONT$E417,attr=$30,chars=0(Well, milk's better for you.)(milk)

t $CDC3 Messaging: Fancy a swift 'arf?
  $CDC3,$1A,$19:$01 #FONT$E417,attr=$30,chars=0(Fancy a swift 'arf? (270))(swift-arf)

t $CDDD Messaging: Last time I saw Trashman
  $CDDD,$3A,$20,$19:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Last time I saw Trashman 'e were)(saw-trashman-1) }
. { #FONT$E417,attr=$30,chars=0(pi-eyed and wiv a sailor.)(saw-trashman-2) }
. TABLE#

t $CE17 Messaging: Hic! *%&#'@ Hic!
@ $CE17 label=Messaging_HicHic
  $CE17,$11,$10:$01 #FONT$E417,attr=$30,chars=0(Hic! *%&#'@ Hic!)(hic)

t $CE28 Messaging: Would you like a Quick Byte?
  $CE28,$26,$20,$05:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Would you like a Quick Byte?)(quick-byte-1) }
. { #FONT$E417,attr=$30,chars=0((150))(quick-byte-2) }
. TABLE#

t $CE4E Messaging: Good grief!
  $CE4E,$19,$18:$01 #FONT$E417,attr=$30,chars=0(Good grief! He liked it.)(good-grief)

t $CE67 Messaging: Come here, I've got something for you
  $CE67,$2F,$20,$0E:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Come  here,  I've got  something)(got-something-1) }
. { #FONT$E417,attr=$30,chars=0(for you. (130))(got-something-2) }
. TABLE#

t $CE96 Messaging: I didn't mean you to eat it
  $CE96,$1D,$1C:$01 #FONT$E417,attr=$30,chars=0(I didn't mean you to eat it.)(eat-it)

t $CEB3 Messaging: Trashman. Try today's special
  $CEB3,$38,$20,$17:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Trashman.  Try today's  special,)(todays-special-1) }
. { #FONT$E417,attr=$30,chars=0(" Paradise Isle " (170))(todays-special-2) }
. TABLE#

t $CEEB Messaging: But some like fried egg floating in a sea of grease
  $CEEB,$34,$20,$13:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(But some like fried egg floating)(fried-egg-1) }
. { #FONT$E417,attr=$30,chars=0(in a sea of grease.)(fried-egg-2) }
. TABLE#

t $CF1F Messaging: Wolfing that lot down like that will slow you down
@ $CF1F label=Messaging_WolfingThatLotDown
  $CF1F,$3A,$20,$19:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Wolfing that lot  down like that)(wolfing-1) }
. { #FONT$E417,attr=$30,chars=0(will slow you down, mate.)(wolfing-2) }
. TABLE#

t $CF59 Messaging: Help! My pet llama's running amok upstairs
  $CF59,$34,$20,$13:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Help!   My pet  llama's  running)(llama-1) }
. { #FONT$E417,attr=$30,chars=0(amok upstairs. (80))(llama-2) }
. TABLE#

t $CF8D Messaging: That was an awesome experience
  $CF8D,$20,$1F:$01 #FONT$E417,attr=$30,chars=0(That was an awesome experience.)(awesome-experience)

t $CFAD Messaging: Want a tip?
  $CFAD,$11,$10:$01 #FONT$E417,attr=$30,chars=0(Want a tip? (45))(tip)

t $CFBE Messaging: Keep off the grass
  $CFBE,$3B,$20,$1A:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Keep off the  grass.  I've taken)(keep-off-the-grass-1) }
. { #FONT$E417,attr=$30,chars=0(the bover to use my hover.)(keep-off-the-grass-2) }
. TABLE#

t $CFF9 Messaging: Want a quick game of Scrabble?
  $CFF9,$26,$20,$05:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Want a quick  game of  Scrabble?)(scrabble-1) }
. { #FONT$E417,attr=$30,chars=0((100))(scrabble-2) }
. TABLE#

t $D01F Messaging: O.K. I give in. TRASHMAN is a proper name
  $D01F,$2D,$20,$0C:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(O.K.   I give in.  TRASHMAN is a)(give-in-1) }
. { #FONT$E417,attr=$30,chars=0(proper name.)(give-in-2) }
. TABLE#

t $D04C Messaging: Could you look at my T.V.?
  $D04C,$20,$1F:$01 #FONT$E417,attr=$30,chars=0(Could you look at my T.V.? (50))(tv)

t $D06C Messaging: I meant mend it, not watch it
  $D06C,$1F,$1E:$01 #FONT$E417,attr=$30,chars=0(I meant mend it, not watch it.)(mend-it)

t $D08B Messaging: Take this thing away. My son is obsessed with it
  $D08B,$37,$20,$16:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Take this thing away.  My son is)(take-away-1) }
. { #FONT$E417,attr=$30,chars=0(obsessed with it. (50))(take-away-2) }
. TABLE#

t $D0C2 Messaging: No one will ever believe I've picked up a Spectrum
  $D0C2,$36,$20,$15:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(No one  will ever  believe  I've)(believe-1) }
. { #FONT$E417,attr=$30,chars=0(picked up a Spectrum.)(believe-2) }
. TABLE#

t $D0F8 Messaging: D'you want a quick game of Space Invaders?
  $D0F8,$2F,$20,$0E:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(D'you want a quick game of Space)(quick-game-1) }
. { #FONT$E417,attr=$30,chars=0(Invaders? (70))(quick-game-2) }
. TABLE#

t $D127 Messaging: Get out! Zapping the cat is not part of the game
  $D127,$32,$20,$11:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Get out!  Zapping the cat is not)(get-out-1) }
. { #FONT$E417,attr=$30,chars=0(part of the game.)(get-out-2) }
. TABLE#

t $D159 Messaging: Can you help with an anagram? It's I, ENIGMA
  $D159,$36,$20,$15:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Can you  help with  an  anagram?)(anagram-1) }
. { #FONT$E417,attr=$30,chars=0(It's  I, ENIGMA. (55))(anagram-2) }
. TABLE#

t $D18F Messaging: I'm no good at anagrams. I can't even imagine the answer
  $D18F,$39,$20,$18:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(I'm no good at anagrams. I can't)(no-good-anagrams-1) }
. { #FONT$E417,attr=$30,chars=0(even imagine the answer.)(no-good-anagrams-2) }
. TABLE#

t $D1C8 Messaging: Could you have a look at my COMMODORE 64?
  $D1C8,$33,$20,$12:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Could  you  have  a look  at  my)(look-at-my-1) }
. { #FONT$E417,attr=$30,chars=0(COMMODORE 64? (95))(look-at-my-2) }
. TABLE#

t $D1FB Messaging: Sorry, but I think the elephant got there first
  $D1FB,$31,$20,$10:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Sorry, but I think the  elephant)(elephant-1) }
. { #FONT$E417,attr=$30,chars=0(got there first.)(elephant-2) }
. TABLE#

t $D22C Messaging: Do you want a copy of 3D Monster Maze?
  $D22C,$2B,$20,$0A:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Do you want a copy of 3D Monster)(monster-1) }
. { #FONT$E417,attr=$30,chars=0(Maze? (55))(monster-2) }
. TABLE#

t $D257 Messaging: What on earth did you expect? An original!
  $D257,$2D,$20,$0C:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(What  on earth  did you  expect?)(earth-1) }
. { #FONT$E417,attr=$30,chars=0(An original!)(earth-2) }
. TABLE#

t $D284 Messaging: Come and see our new puppy
  $D284,$25,$20,$04:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Come  and  see  our  new   puppy)(puppy-1) }
. { #FONT$E417,attr=$30,chars=0((70))(puppy-2) }
. TABLE#

t $D2A9 Messaging: We had our old dog put down when the last Trashman bit him
  $D2A9,$3B,$20,$1A:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(We had our old dog put down when)(put-down-1) }
. { #FONT$E417,attr=$30,chars=0(the last Trashman bit him.)(put-down-2) }
. TABLE#

t $D2E4 Messaging: Do you think I'm a megalomaniac?
  $D2E4,$25,$20,$04:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Do you think I'm a megalomaniac?)(megalomaniac-1) }
. { #FONT$E417,attr=$30,chars=0((50))(megalomaniac-2) }
. TABLE#

t $D309 Messaging: Just give me a ZX81, and I'll control the world
  $D309,$33,$20,$12:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Just  give  me a  ZX81, and I'll)(zx81-1) }
. { #FONT$E417,attr=$30,chars=0(control the world.)(zx81-2) }
. TABLE#

t $D33C Messaging: Do you want to play some games on my Spectrum?
  $D33C,$35,$20,$14:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Do you want to  play some  games)(play-games-1) }
. { #FONT$E417,attr=$30,chars=0(on my Spectrum? (95))(play-games-2) }
. TABLE#

t $D371 Messaging: That game was Virgin on the impossible !!!!
  $D371,$30,$20,$0F:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(That  game  was  Virgin  on  the)(virgin-1) }
. { #FONT$E417,attr=$30,chars=0(impossible !!!!)(virgin-2) }
. TABLE#

t $D3A1 Messaging: Have you seen that delinquent son of mine?
  $D3A1,$32,$20,$11:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Have you  seen  that  delinquent)(delinquent-1) }
. { #FONT$E417,attr=$30,chars=0(son of mine? (55))(delinquent-2) }
. TABLE#

t $D3D3 Messaging: Yes,you're right. You could call him a Maniac Minor
  $D3D3,$34,$20,$13:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Yes,you're right. You could call)(right-1) }
. { #FONT$E417,attr=$30,chars=0(him a Maniac Minor.)(right-2) }
. TABLE#

t $D407 Messaging: Come and look at my Spectrum with 4 megabyte memory
  $D407,$3D,$20,$1C:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Come  and look  at  my  Spectrum)(spectrum-1) }
. { #FONT$E417,attr=$30,chars=0(with 4 megabyte memory. (60))(spectrum-2) }
. TABLE#

t $D444 Messaging: Only trouble is, I've forgotten what I wanted it for
  $D444,$36,$20,$15:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Only trouble is,  I've forgotten)(forgotten-1) }
. { #FONT$E417,attr=$30,chars=0(what I wanted it for.)(forgotten-2) }
. TABLE#

t $D47A Messaging: Help!! The curtains are on fire!
  $D47A,$25,$20,$04:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Help!! The curtains are on fire!)(curtains-1) }
. { #FONT$E417,attr=$30,chars=0((75))(curtains-2) }
. TABLE#

t $D49F Messaging: A tongue of flame came out of my Dragon
  $D49F,$28,$20,$07:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(A tongue of flame came out of my)(tongue-1) }
. { #FONT$E417,attr=$30,chars=0(Dragon.)(tongue-2) }
. TABLE#

t $D4C7 Messaging: Oh dear, what shall I do? My husband's been taken away
  $D4C7,$3F,$20,$1E:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Oh  dear,  what shall  I do?  My)(shall-i-do-1) }
. { #FONT$E417,attr=$30,chars=0(husband's been taken away.(75))(shall-i-do-2) }
. TABLE#

t $D506 Messaging: He was a Schizoid
  $D506,$13,$12:$01 #FONT$E417,attr=$30,chars=0(He was a Schizoid.)(schizoid)

t $D519 Messaging: Do you want a tip?
  $D519,$18,$17:$01 #FONT$E417,attr=$30,chars=0(Do you want a tip? (50))(want-tip)

t $D531 Messaging: That's got Trashman worried. I'm his tax inspector
  $D531,$33,$20,$12:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(That's got Trashman worried. I'm)(worried-1) }
. { #FONT$E417,attr=$30,chars=0(his tax inspector.)(worried-2) }
. TABLE#

t $D564 Messaging: Give us a hand mate
  $D564,$1A,$19:$01 #FONT$E417,attr=$30,chars=0(Give us a hand mate. (60))(hand)

t $D57E Messaging: That was NOT funny. Applauding while everything collapsed
  $D57E,$3C,$20,$1B:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(That  was NOT funny.  Applauding)(not-funny-1) }
. { #FONT$E417,attr=$30,chars=0(while everything collapsed.)(not-funny-2) }
. TABLE#

t $D5BA Messaging: Please help find my little doggy woggy
  $D5BA,$2C,$20,$0B:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Please help find my little doggy)(doggy-1) }
. { #FONT$E417,attr=$30,chars=0(woggy. (65))(doggy-2) }
. TABLE#

t $D5E6 Messaging: You've been a great help. At least I know where he's been
  $D5E6,$3E,$20,$1D:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(You've  been  a great  help.  At)(great-help-1) }
. { #FONT$E417,attr=$30,chars=0(least I know where he's been.)(great-help-2) }
. TABLE#

t $D624 Messaging: Are you the chimney sweep?
  $D624,$20,$1F:$01 #FONT$E417,attr=$30,chars=0(Are you the chimney sweep? (80))(chimney-sweep)

t $D644 Messaging: Sorry, but you must admit you do have the same complexion
  $D644,$3A,$20,$19:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Sorry, but you must admit you do)(admit-1) }
. { #FONT$E417,attr=$30,chars=0(have the same complexion.)(admit-2) }
. TABLE#

t $D67E Messaging: Hallo Trashman. Your move this week, I think?
  $D67E,$34,$20,$13:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Hallo Trashman.  Your move  this)(hallo-1) }
. { #FONT$E417,attr=$30,chars=0(week, I think? (65))(hallo-2) }
. TABLE#

t $D6B2 Messaging: You know, it might be quicker playing chess with a computer
  $D6B2,$3F,$20,$1E:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(You know,  it  might be  quicker)(quicker-1) }
. { #FONT$E417,attr=$30,chars=0(playing chess with a computer.)(quicker-2) }
. TABLE#

t $D6F1 Messaging: Come and see the computer my Auntie gave me
  $D6F1,$35,$20,$14:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Come  and  see the  computer  my)(computer-1) }
. { #FONT$E417,attr=$30,chars=0(Auntie gave me. (45))(computer-2) }
. TABLE#

t $D726 Messaging: Oh good! I thought I might need a licence for it
  $D726,$32,$20,$11:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Oh good!  I thought I might need)(oh-good-1) }
. { #FONT$E417,attr=$30,chars=0(a licence for it.)(oh-good-2) }
. TABLE#

t $D758 Messaging: Hey, Bilbo, help me solve this adventure
  $D758,$31,$20,$10:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Hey, Bilbo,  help me  solve this)(bilbo-1) }
. { #FONT$E417,attr=$30,chars=0(adventure. (100))(bilbo-2) }
. TABLE#

t $D789 Messaging: You're no help. HOPPIT!
  $D789,$18,$17:$01 #FONT$E417,attr=$30,chars=0(You're no help. HOPPIT!)(no-help)

t $D7A1 Messaging: Help me! Sophie's drowning. Can you revive her?
  $D7A1,$35,$20,$14:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(Help  me! Sophie's drowning. Can)(drowning-1) }
. { #FONT$E417,attr=$30,chars=0(you revive her? (85))(drowning-2) }
. TABLE#

t $D7D6 Messaging: If you hadn't laughed, the gold-fish might still be alive
  $D7D6,$3B,$20,$1A:$01 #TABLE(default)
. { #FONT$E417,attr=$30,chars=0(If you hadn't laughed, the gold-)(laughed-1) }
. { #FONT$E417,attr=$30,chars=0(fish might still be alive.)(laughed-2) }
. TABLE#

b $D811 Data: Bonus Messaging Pointers

b $D813 Data: Level 1
@ $D813 label=Data_Level1
W $D813,$02 Pointer to string for number of bins to collect: #R(#PEEK(#PC) + #PEEK(#PC + $01) * $100).
  $D815,$02 Time available for this level.
T $D823,$0E,$0D:$01 Street name: "#STR$D823,$08($b==$80)".

b $D9A8 Data: Level 2
@ $D9A8 label=Data_Level2
W $D9A8,$02 Pointer to string for number of bins to collect: #R(#PEEK(#PC) + #PEEK(#PC + $01) * $100).
  $D9AA,$02 Time available for this level.
T $D9B8,$0E,$0D:$01 Street name: "#STR$D9B8,$08($b==$80)".

b $DB55 Data: Level 3
@ $DB55 label=Data_Level3
W $DB55,$02 Pointer to string for number of bins to collect: #R(#PEEK(#PC) + #PEEK(#PC + $01) * $100).
  $DB57,$02 Time available for this level.
T $DB65,$0E,$0D:$01 Street name: "#STR$DB65,$08($b==$80)".

b $DD02 Data: Level 4
@ $DD02 label=Data_Level4
W $DD02,$02 Pointer to string for number of bins to collect: #R(#PEEK(#PC) + #PEEK(#PC + $01) * $100).
  $DD04,$02 Time available for this level.
T $DD12,$0E,$0D:$01 Street name: "#STR$DD12,$08($b==$80)".

b $DEAF Data: Level 5
@ $DEAF label=Data_Level5
W $DEAF,$02 Pointer to string for number of bins to collect: #R(#PEEK(#PC) + #PEEK(#PC + $01) * $100).
  $DEB1,$02 Time available for this level.
T $DEBF,$0E,$0D:$01 Street name: "#STR$DEBF,$08($b==$80)".

b $E075 Data: Level 6
@ $E075 label=Data_Level6
W $E075,$02 Pointer to string for number of bins to collect: #R(#PEEK(#PC) + #PEEK(#PC + $01) * $100).
  $E077,$02 Time available for this level.
T $E085,$0E,$0D:$01 Street name: "#STR$E085,$08($b==$80)".

b $E23A Data: Level 7
@ $E23A label=Data_Level7
W $E23A,$02 Pointer to string for number of bins to collect: #R(#PEEK(#PC) + #PEEK(#PC + $01) * $100).
  $E23C,$02 Time available for this level.
T $E24A,$0E,$0D:$01 Street name: "#STR$E24A,$08($b==$80)".

b $E417 Font UDGs
@ $E417 label=Font
  $E417,$08 #UDG(#PC,attr=56)
L $E417,$08,$5E

b $FE80

b $FFE8
