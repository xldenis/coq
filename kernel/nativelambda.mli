(************************************************************************)
(*         *   The Coq Proof Assistant / The Coq Development Team       *)
(*  v      *   INRIA, CNRS and contributors - Copyright 1999-2018       *)
(* <O___,, *       (see CREDITS file for the list of authors)           *)
(*   \VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)
open Names
open Constr
open Environ
open Nativevalues

(** This file defines the lambda code generation phase of the native compiler *)
type prefix = string

type lambda =
  | Lrel          of Name.t * int
  | Lvar          of Id.t
  | Lmeta         of metavariable * lambda (* type *)
  | Levar         of Evar.t * lambda array (* arguments *)
  | Lprod         of lambda * lambda
  | Llam          of Name.t Context.binder_annot array * lambda
  | Lrec          of Name.t Context.binder_annot * lambda
  | Llet          of Name.t Context.binder_annot * lambda * lambda
  | Lapp          of lambda * lambda array
  | Lconst        of prefix * pconstant
  | Lproj         of prefix * inductive * int (* prefix, inductive, index starting from 0 *)
  | Lprim         of prefix * pconstant * CPrimitives.t * lambda array
  | Lcase         of annot_sw * lambda * lambda * lam_branches
                  (* annotations, term being matched, accu, branches *)
  | Lif           of lambda * lambda * lambda
  | Lfix          of (int array * (string * inductive) array * int) * fix_decl
  | Lcofix        of int * fix_decl
  | Lmakeblock    of prefix * pconstructor * int * lambda array
                  (* prefix, constructor Name.t, constructor tag, arguments *)
        (* A fully applied constructor *)
  | Lconstruct    of prefix * pconstructor (* prefix, constructor Name.t *)
        (* A partially applied constructor *)
  | Luint         of Uint63.t
  | Lval          of Nativevalues.t
  | Lsort         of Sorts.t
  | Lind          of prefix * pinductive
  | Llazy
  | Lforce
  | Lconst_accu   of prefix * pconstant

and lam_branches = (constructor * Name.t Context.binder_annot array * lambda) array

and fix_decl =  Name.t Context.binder_annot array * lambda array * lambda array

type evars =
    { evars_val : existential -> constr option;
      evars_metas : metavariable -> types }

val empty_evars : evars

val decompose_Llam : lambda -> Name.t Context.binder_annot array * lambda
val decompose_Llam_Llet : lambda -> (Name.t Context.binder_annot * lambda option) array * lambda

val is_lazy : constr -> bool
val mk_lazy : lambda -> lambda

val get_mind_prefix : env -> MutInd.t -> string

val get_alias : env -> pconstant -> pconstant

val lambda_of_constr : env -> evars -> Constr.constr -> lambda
