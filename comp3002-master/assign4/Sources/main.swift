import Foundation

print("ahhh")
//let parserInput: String = try String(contentsOf: URL(fileURLWithPath: "Sources/FSMBuilder/parserFSMs.txt"), encoding: .utf8)
//let scannerInput: String = try String(contentsOf: URL(fileURLWithPath: "Sources/FSMBuilder/scannerFSMs.txt"), encoding: .utf8)

let parserInput = """
parser
   //This is a test of parser based FSMs. 

   //These are the easy ones first...
   fsm1 = ; //The empty string
   fsm2 = a; //The attribute should be "RS" because its a terminal. 
   fsm3 = "hi"; //This should result in an FSM recognizing the string with attribues "RS" (like the above fsm).
      //Note: If this were in a scanner, it would be an FSM recognizing $h and $i.
   fsm4 = A; //The attribute should be "RSN" because its a nonterminal. The grammar object is fudged to accept this as a parser nonterminal default.
   fsm5 = a?; //0 or 1 a
   fsm6 = a+; //1 or more a's
   fsm7 = a*; //0 or more a's
   fsm8 = a | b | c | d; //a or b or c or d

   //These are the medium-hard ones
   fsm9 = a b c d; //a followed by b followed by c followed by d.

   //If you implemented concatenation properly, you now get the chance
   //to test it with 4 fsms to concatenate... We specifically mentioned
   //these in the notes... They should all be slightly different.
   fsm10a = a+ b+;
   fsm10b = a+ b*;
   fsm10c = a* b+;
   fsm10d = a* b*;

   //The next series of 3 FSMs is testing the notion of an FSM
   //playing the role of a macro...

   //DANGER DANGER DANGER: The following fsm9 uses the pre-built fsm called fsm2
   //that was recorded in the finite state machine builder up above...
   //YOU SHOULD NOT HAVE A TRANSITION CALLED fsm2. You should have made a
   //copy of fsm2 and returned it. But just before you return the copy,
   //print fsm2 to prove that it has NOT been modified.

   fsm11 = fsm2 [noStack keep]; 
    //The attribute for fsm2 should still be "RS" but the attribute
        //for fsm11 should be "RK". You'll need to have re-printed fsm2 verify this.

   fsm12 = {fsm4}; //Braces mean LOOK. Note that fsm4 had the read attribute but fsm12 has the look attribute. Make sure fsm4 is still correct.
   fsm13 = fsm4 fsm5+; //fsm13 will be a mess to look at but neither fsm4 nor fsm5 should be buggered up...

   //This is the end of macro testing; i.e., tests where the fsms are used as transitions...

   fsm14 = (a* | b*); //Make sure the FSM is correct... It might not look like you expected.
   fsm15 = a* b; //Two simple tests
   fsm16 = a b*; //of concatenate

   complex1 = a? b* c+ d;
    
   //NOTE: You will need to implement reduce to eliminate useless states and transitions
   //in addition to implementing - and & below    
   fsm17 = (a*) - ((a a)*); //Should recognize only an odd number of a's (you took away the even ones).
   fsm18 = (a*) & ((a a)*); //Should recognize only an even number of a's.

   //The following illustrates why you need reduce to be use by operation -.
   //FSM complex2 is not so complex after reduce runs...
   complex2 = ((a a)* | b c | d) - (a* | b c | g); //Should recognize d. 
        //Why does it recognize d?
    //Take an even number of a's via (a a)* one the left but take away a* on the right. (so nothing left)
    //Take "b c" on the left and take away "b c" on the right (so nothing left)
    //Take "d" on the left - "g" on the right (so d alone since there was no g to take away).

"""

let scannerInput = """
scanner
    //NOTE: All transitions 256 should be converted to integers...

    //For scanners, the following does not mean build an FSM with a string transition for "0123", it
    //means build a 2 state FSM with 4 transitions: one for $0, one for $1, one for $2, and one
    //for $3.
    digit = "0123"; //There should be 4 transitions. The attribute should be "RK". (note: character $0 is ascii 48)
    fsm2 = $0 .. $3; //4 transitions. Just a new notation equivalent to fsm1.
    fsm3 = 0 .. 3; //4 transition. The same new notation but with the transitions given as integers.
       //They are clearly unprintabble characters.
    fsm4 = 0 | 1 | 2 | 3; //Uses standard or routine. Note: integer inputs means they are unprintable...
    fsm5 = $0 | $1 | $2 | $3; //Like above but these are printable once you convert to integers, it will have 
       //ascii value 48 for $0, 49 for $1, ....

    tab = 9 [noKeep];
    carriageReturn = 13 [noKeep];
    lineFeed = 10 [noKeep];
    formFeed = 12 [noKeep];
    blank = 32 [noKeep];
    lineEnd = carriageReturn | lineFeed  | formFeed;
    space = blank | tab | lineEnd;
    all = "0123abc;+-/" [read keep] | space | lineEnd; //The 5 non-printable characters should be "R"; others "RK".
    endOfFileCharacter = 256; //Not a valid ascii character.

    //The following is an example scanner production... The "+" is new but the "=> Number" is stuff your last assignment could already handle.
    number = digit+ => Number; //This should recognize 1 or more digits followed by a walk routine for semantic transition 
        //#buildToken: with parameters "Number", a string, NOT a token) in Smalltalk. In Swift, the : is missing from #buildToken:.
    // This last one should work from your old code.
            
    //NOTE: The - operation is difficult... But you already implemented it in parserFSMs.
    nonDigit = {all - digit}; //The attributes should be "L".

    //The following describes a comment in the C++ style (like this comment).
    //It's pretty complicated as an FSM... Look at it when you print it.
    comment =
        ($/ [noKeep] {all - $/} #syntaxError: ["// is a comment, / alone is not valid"])
      | ($/ [noKeep] $/ [noKeep]
                (all [noKeep] - lineEnd [noKeep])*
            (
                lineEnd [noKeep] |
                {endOfFileCharacter}
            )
        );
"""
// part 1

// let testGrammar : Grammar = Grammar();

// testGrammar.addNonterminal("#A");

// Grammar.activeGrammar = testGrammar;

// print(Grammar.defaultsFor("#A"));

// testGrammar.type = "parser";

// print(Grammar.defaultsFor("#A"));

// part 2 //

print(FSMBuilder.example1(parserFSM: scannerInput, scannerFSMs: scannerInput));

// Relation<Int, String>.example4();