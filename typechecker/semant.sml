signature SEMANT = 
sig 
	val transProg : Absyn.exp -> unit
end






structure Semant :> SEMANT = 
struct 
	structure A = Absyn
	structure E = Env
	structure Translate = struct type exp = unit end
	type venv =  E.enventry Symbol.table
	type tenv = Types.ty Symbol.table
	type expty = {exp: Translate.exp , ty: Types.ty}

fun checkInt ({exp,ty},pos) = 
			case ty of Types.INT => ()
				| _ => ErrorMsg.error pos "integer required"

fun checkString ({exp,ty},pos) = 
			case ty of Types.STRING => ()
				| _ => ErrorMsg.error pos "string required"

fun checkComparable ({exp,ty} , expty2 , pos) = 
			case ty of 
				  Types.INT => checkInt (expty2,pos)
				| Types.STRING => checkString (expty2,pos)
				| _ => ErrorMsg.error pos "string or integer required"

(* ASK HILTON about array and record type checking*)
(*
fun checkEqualable ({exp=_,ty=ty1},{()),ty = ty2},pos ) = 
			case ty1 of Types.INT => checkInt ({(),ty2},pos)
				| Types.STRING => checkString ({(),ty2},pos)
				| Types.ARRAY(arrayTy,unique) => ()
				| Types.RECORD l => ()
				| _ => ErrorMsg.error pos "string or integer required"
*)
fun transExp (venv, tenv) = 
	let fun trexp (A.OpExp {left, oper, right, pos}) = 
			if 
				oper = A.PlusOp orelse oper = A.MinusOp orelse oper = A.TimesOp orelse oper = A.DivideOp 
			then 
					(checkInt(trexp left, pos); 
					checkInt(trexp right, pos);
					{exp = (),ty=Types.INT})
			else if oper = A.EqOp orelse oper = A.NeqOp orelse oper = A.GeOp orelse oper = A.LeOp orelse oper = A.GtOp orelse oper = A.LtOp 
					
			then
					(checkComparable(trexp left, trexp right, pos); 
					{exp = (),ty=Types.INT})
			else
        			(ErrorMsg.error pos "error";
        			{exp=(), ty=Types.INT})
        | 	trexp (A.IntExp i) = {exp=(),ty=Types.INT}
        |	trexp (A.StringExp (s,pos)) = {exp=(),ty=Types.STRING}
		in 
			trexp 
		end


fun transProg ast = 
	let 
		val {exp=result,ty=_} = transExp (E.base_venv,E.base_tenv) ast
	in 
		result
	end

end