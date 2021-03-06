signature FRAME =
sig type frame
    type access

    val newFrame : {name: Temp.label, formals: bool list} -> frame
    val name : frame -> Temp.label
    val formals : frame -> access list  
    val allocLocal : frame -> bool -> access
    val exp : access -> Tree.exp -> Tree.exp
    val externalCall: string * Tree.exp list -> Tree.exp

    val FP : Temp.temp
    val RV : Temp.temp
    val wordsize: int

    datatype frag = PROC of {body: Tree.stm, frame: frame}
    				| STRING of Temp.label * string
    (*val frags: frag list ref*)
   	val procEntryExit1 : frame * Tree.stm -> Tree.stm
    val addFrag : frag -> unit
    val getResult : unit -> frag list
    val printFragList : frag list -> unit
    val clearFrags: unit -> unit

end