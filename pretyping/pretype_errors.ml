
(* $Id$ *)

open Names
open Sign
open Environ
open Type_errors
open Rawterm

let raise_pretype_error (loc,k,ctx,te) =
  raise (Stdpp.Exc_located (loc, TypeError(k,ctx,te)))

let error_var_not_found_loc loc k s =
  raise_pretype_error (loc,k, Global.context() (*bidon*), VarNotFound s)

let error_cant_find_case_type_loc loc env expr =
  raise_pretype_error (loc, CCI, context env, CantFindCaseType expr)

let error_actual_type_loc loc env c actty expty =
  raise_pretype_error (loc, CCI, context env, ActualType (c,actty,expty))

let error_cant_apply_not_functional_loc loc env rator randl =
  raise_pretype_error
    (loc,CCI,context env, CantApplyNonFunctional (rator,randl))

let error_cant_apply_bad_type_loc loc env t rator randl =
  raise_pretype_error (loc, CCI, context env, CantApplyBadType (t,rator,randl))

let error_ill_formed_branch k env c i actty expty =
  raise (TypeError (k, context env, IllFormedBranch (c,i,actty,expty)))

let error_number_branches_loc loc k env c ct expn =
  raise_pretype_error (loc, k, context env, NumberBranches (c,ct,expn))

let error_case_not_inductive_loc loc k env c ct =
  raise_pretype_error (loc, k, context env, CaseNotInductive (c,ct))

(* Pattern-matching errors *)

let error_bad_constructor_loc loc k cstr ind =
  raise_pretype_error (loc, k, Global.context(), BadConstructor (cstr,ind))

let error_wrong_numarg_constructor_loc loc k c n =
  raise_pretype_error (loc, k, Global.context(), WrongNumargConstructor (c,n))

let error_wrong_predicate_arity_loc loc k env c n1 n2 =
  raise_pretype_error (loc, k, context env, WrongPredicateArity (c,n1,n2))

let error_needs_inversion k env x t =
  raise (TypeError (k, context env, NeedsInversion (x,t)))


let error_ill_formed_branch_loc loc k env c i actty expty =
  raise_pretype_error (loc, k, context env, IllFormedBranch (c,i,actty,expty))

let error_occur_check k env ev c =
  raise (TypeError (k, context env, OccurCheck (ev,c)))

let error_not_clean k env ev c =
  raise (TypeError (k, context env, NotClean (ev,c)))

