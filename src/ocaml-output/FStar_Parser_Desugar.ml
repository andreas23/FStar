
let as_imp = (fun _43_1 -> (match (_43_1) with
| (FStar_Parser_AST.Hash) | (FStar_Parser_AST.FsTypApp) -> begin
Some (FStar_Absyn_Syntax.Implicit)
end
| _43_34 -> begin
None
end))

let arg_withimp_e = (fun imp t -> (t, (as_imp imp)))

let arg_withimp_t = (fun imp t -> (match (imp) with
| FStar_Parser_AST.Hash -> begin
(t, Some (FStar_Absyn_Syntax.Implicit))
end
| _43_41 -> begin
(t, None)
end))

let contains_binder = (fun binders -> (FStar_All.pipe_right binders (FStar_Util.for_some (fun b -> (match (b.FStar_Parser_AST.b) with
| FStar_Parser_AST.Annotated (_43_45) -> begin
true
end
| _43_48 -> begin
false
end)))))

let rec unparen = (fun t -> (match (t.FStar_Parser_AST.tm) with
| FStar_Parser_AST.Paren (t) -> begin
(unparen t)
end
| _43_53 -> begin
t
end))

let rec unlabel = (fun t -> (match (t.FStar_Parser_AST.tm) with
| FStar_Parser_AST.Paren (t) -> begin
(unlabel t)
end
| FStar_Parser_AST.Labeled (t, _43_59, _43_61) -> begin
(unlabel t)
end
| _43_65 -> begin
t
end))

let kind_star = (fun r -> (let _109_17 = (let _109_16 = (FStar_Absyn_Syntax.lid_of_path (("Type")::[]) r)
in FStar_Parser_AST.Name (_109_16))
in (FStar_Parser_AST.mk_term _109_17 r FStar_Parser_AST.Kind)))

let compile_op = (fun arity s -> (let name_of_char = (fun _43_2 -> (match (_43_2) with
| '&' -> begin
"Amp"
end
| '@' -> begin
"At"
end
| '+' -> begin
"Plus"
end
| '-' when (arity = 1) -> begin
"Minus"
end
| '-' -> begin
"Subtraction"
end
| '/' -> begin
"Slash"
end
| '<' -> begin
"Less"
end
| '=' -> begin
"Equals"
end
| '>' -> begin
"Greater"
end
| '_' -> begin
"Underscore"
end
| '|' -> begin
"Bar"
end
| '!' -> begin
"Bang"
end
| '^' -> begin
"Hat"
end
| '%' -> begin
"Percent"
end
| '*' -> begin
"Star"
end
| '?' -> begin
"Question"
end
| ':' -> begin
"Colon"
end
| _43_88 -> begin
"UNKNOWN"
end))
in (let rec aux = (fun i -> (match ((i = (FStar_String.length s))) with
| true -> begin
[]
end
| false -> begin
(let _109_28 = (let _109_26 = (FStar_Util.char_at s i)
in (name_of_char _109_26))
in (let _109_27 = (aux (i + 1))
in (_109_28)::_109_27))
end))
in (let _109_30 = (let _109_29 = (aux 0)
in (FStar_String.concat "_" _109_29))
in (Prims.strcat "op_" _109_30)))))

let compile_op_lid = (fun n s r -> (let _109_40 = (let _109_39 = (let _109_38 = (let _109_37 = (compile_op n s)
in (_109_37, r))
in (FStar_Absyn_Syntax.mk_ident _109_38))
in (_109_39)::[])
in (FStar_All.pipe_right _109_40 FStar_Absyn_Syntax.lid_of_ids)))

let op_as_vlid = (fun env arity rng s -> (let r = (fun l -> (let _109_51 = (FStar_Absyn_Util.set_lid_range l rng)
in Some (_109_51)))
in (let fallback = (fun _43_102 -> (match (()) with
| () -> begin
(match (s) with
| "=" -> begin
(r FStar_Absyn_Const.op_Eq)
end
| ":=" -> begin
(r FStar_Absyn_Const.op_ColonEq)
end
| "<" -> begin
(r FStar_Absyn_Const.op_LT)
end
| "<=" -> begin
(r FStar_Absyn_Const.op_LTE)
end
| ">" -> begin
(r FStar_Absyn_Const.op_GT)
end
| ">=" -> begin
(r FStar_Absyn_Const.op_GTE)
end
| "&&" -> begin
(r FStar_Absyn_Const.op_And)
end
| "||" -> begin
(r FStar_Absyn_Const.op_Or)
end
| "*" -> begin
(r FStar_Absyn_Const.op_Multiply)
end
| "+" -> begin
(r FStar_Absyn_Const.op_Addition)
end
| "-" when (arity = 1) -> begin
(r FStar_Absyn_Const.op_Minus)
end
| "-" -> begin
(r FStar_Absyn_Const.op_Subtraction)
end
| "/" -> begin
(r FStar_Absyn_Const.op_Division)
end
| "%" -> begin
(r FStar_Absyn_Const.op_Modulus)
end
| "!" -> begin
(r FStar_Absyn_Const.read_lid)
end
| "@" -> begin
(r FStar_Absyn_Const.list_append_lid)
end
| "^" -> begin
(r FStar_Absyn_Const.strcat_lid)
end
| "|>" -> begin
(r FStar_Absyn_Const.pipe_right_lid)
end
| "<|" -> begin
(r FStar_Absyn_Const.pipe_left_lid)
end
| "<>" -> begin
(r FStar_Absyn_Const.op_notEq)
end
| _43_124 -> begin
None
end)
end))
in (match ((let _109_54 = (compile_op_lid arity s rng)
in (FStar_Parser_DesugarEnv.try_lookup_lid env _109_54))) with
| Some ({FStar_Absyn_Syntax.n = FStar_Absyn_Syntax.Exp_fvar (fv, _43_135); FStar_Absyn_Syntax.tk = _43_132; FStar_Absyn_Syntax.pos = _43_130; FStar_Absyn_Syntax.fvs = _43_128; FStar_Absyn_Syntax.uvs = _43_126}) -> begin
Some (fv.FStar_Absyn_Syntax.v)
end
| _43_141 -> begin
(fallback ())
end))))

let op_as_tylid = (fun env arity rng s -> (let r = (fun l -> (let _109_65 = (FStar_Absyn_Util.set_lid_range l rng)
in Some (_109_65)))
in (match (s) with
| "~" -> begin
(r FStar_Absyn_Const.not_lid)
end
| "==" -> begin
(r FStar_Absyn_Const.eq2_lid)
end
| "=!=" -> begin
(r FStar_Absyn_Const.neq2_lid)
end
| "<<" -> begin
(r FStar_Absyn_Const.precedes_lid)
end
| "/\\" -> begin
(r FStar_Absyn_Const.and_lid)
end
| "\\/" -> begin
(r FStar_Absyn_Const.or_lid)
end
| "==>" -> begin
(r FStar_Absyn_Const.imp_lid)
end
| "<==>" -> begin
(r FStar_Absyn_Const.iff_lid)
end
| s -> begin
(match ((let _109_66 = (compile_op_lid arity s rng)
in (FStar_Parser_DesugarEnv.try_lookup_typ_name env _109_66))) with
| Some ({FStar_Absyn_Syntax.n = FStar_Absyn_Syntax.Typ_const (ftv); FStar_Absyn_Syntax.tk = _43_164; FStar_Absyn_Syntax.pos = _43_162; FStar_Absyn_Syntax.fvs = _43_160; FStar_Absyn_Syntax.uvs = _43_158}) -> begin
Some (ftv.FStar_Absyn_Syntax.v)
end
| _43_170 -> begin
None
end)
end)))

let rec is_type = (fun env t -> (match ((t.FStar_Parser_AST.level = FStar_Parser_AST.Type)) with
| true -> begin
true
end
| false -> begin
(match ((let _109_73 = (unparen t)
in _109_73.FStar_Parser_AST.tm)) with
| FStar_Parser_AST.Wild -> begin
true
end
| FStar_Parser_AST.Labeled (_43_175) -> begin
true
end
| FStar_Parser_AST.Op ("*", hd::_43_179) -> begin
(is_type env hd)
end
| (FStar_Parser_AST.Op ("==", _)) | (FStar_Parser_AST.Op ("=!=", _)) | (FStar_Parser_AST.Op ("~", _)) | (FStar_Parser_AST.Op ("/\\", _)) | (FStar_Parser_AST.Op ("\\/", _)) | (FStar_Parser_AST.Op ("==>", _)) | (FStar_Parser_AST.Op ("<==>", _)) | (FStar_Parser_AST.Op ("<<", _)) -> begin
true
end
| FStar_Parser_AST.Op (s, args) -> begin
(match ((op_as_tylid env (FStar_List.length args) t.FStar_Parser_AST.range s)) with
| None -> begin
false
end
| _43_230 -> begin
true
end)
end
| (FStar_Parser_AST.QForall (_)) | (FStar_Parser_AST.QExists (_)) | (FStar_Parser_AST.Sum (_)) | (FStar_Parser_AST.Refine (_)) | (FStar_Parser_AST.Tvar (_)) | (FStar_Parser_AST.NamedTyp (_)) -> begin
true
end
| (FStar_Parser_AST.Var (l)) | (FStar_Parser_AST.Name (l)) when ((FStar_List.length l.FStar_Absyn_Syntax.ns) = 0) -> begin
(match ((FStar_Parser_DesugarEnv.try_lookup_typ_var env l.FStar_Absyn_Syntax.ident)) with
| Some (_43_253) -> begin
true
end
| _43_256 -> begin
(FStar_Parser_DesugarEnv.is_type_lid env l)
end)
end
| (FStar_Parser_AST.Var (l)) | (FStar_Parser_AST.Name (l)) | (FStar_Parser_AST.Construct (l, _)) -> begin
(FStar_Parser_DesugarEnv.is_type_lid env l)
end
| (FStar_Parser_AST.App ({FStar_Parser_AST.tm = FStar_Parser_AST.Var (l); FStar_Parser_AST.range = _; FStar_Parser_AST.level = _}, arg, FStar_Parser_AST.Nothing)) | (FStar_Parser_AST.App ({FStar_Parser_AST.tm = FStar_Parser_AST.Name (l); FStar_Parser_AST.range = _; FStar_Parser_AST.level = _}, arg, FStar_Parser_AST.Nothing)) when (l.FStar_Absyn_Syntax.str = "ref") -> begin
(is_type env arg)
end
| (FStar_Parser_AST.App (t, _, _)) | (FStar_Parser_AST.Paren (t)) | (FStar_Parser_AST.Ascribed (t, _)) -> begin
(is_type env t)
end
| FStar_Parser_AST.Product (_43_297, t) -> begin
(not ((is_kind env t)))
end
| FStar_Parser_AST.If (t, t1, t2) -> begin
(((is_type env t) || (is_type env t1)) || (is_type env t2))
end
| FStar_Parser_AST.Abs (pats, t) -> begin
(let rec aux = (fun env pats -> (match (pats) with
| [] -> begin
(is_type env t)
end
| hd::pats -> begin
(match (hd.FStar_Parser_AST.pat) with
| (FStar_Parser_AST.PatWild) | (FStar_Parser_AST.PatVar (_)) -> begin
(aux env pats)
end
| FStar_Parser_AST.PatTvar (id, _43_323) -> begin
(let _43_329 = (FStar_Parser_DesugarEnv.push_local_tbinding env id)
in (match (_43_329) with
| (env, _43_328) -> begin
(aux env pats)
end))
end
| FStar_Parser_AST.PatAscribed (p, tm) -> begin
(let env = (match ((is_kind env tm)) with
| true -> begin
(match (p.FStar_Parser_AST.pat) with
| (FStar_Parser_AST.PatVar (id, _)) | (FStar_Parser_AST.PatTvar (id, _)) -> begin
(let _109_78 = (FStar_Parser_DesugarEnv.push_local_tbinding env id)
in (FStar_All.pipe_right _109_78 Prims.fst))
end
| _43_344 -> begin
env
end)
end
| false -> begin
env
end)
in (aux env pats))
end
| _43_347 -> begin
false
end)
end))
in (aux env pats))
end
| _43_349 -> begin
false
end)
end))
and is_kind = (fun env t -> (match ((t.FStar_Parser_AST.level = FStar_Parser_AST.Kind)) with
| true -> begin
true
end
| false -> begin
(match ((let _109_81 = (unparen t)
in _109_81.FStar_Parser_AST.tm)) with
| FStar_Parser_AST.Name ({FStar_Absyn_Syntax.ns = _43_358; FStar_Absyn_Syntax.ident = _43_356; FStar_Absyn_Syntax.nsstr = _43_354; FStar_Absyn_Syntax.str = "Type"}) -> begin
true
end
| FStar_Parser_AST.Product (_43_362, t) -> begin
(is_kind env t)
end
| FStar_Parser_AST.Paren (t) -> begin
(is_kind env t)
end
| (FStar_Parser_AST.Construct (l, _)) | (FStar_Parser_AST.Name (l)) -> begin
(FStar_Parser_DesugarEnv.is_kind_abbrev env l)
end
| _43_375 -> begin
false
end)
end))

let rec is_type_binder = (fun env b -> (match ((b.FStar_Parser_AST.blevel = FStar_Parser_AST.Formula)) with
| true -> begin
(match (b.FStar_Parser_AST.b) with
| FStar_Parser_AST.Variable (_43_379) -> begin
false
end
| (FStar_Parser_AST.TAnnotated (_)) | (FStar_Parser_AST.TVariable (_)) -> begin
true
end
| (FStar_Parser_AST.Annotated (_, t)) | (FStar_Parser_AST.NoName (t)) -> begin
(is_kind env t)
end)
end
| false -> begin
(match (b.FStar_Parser_AST.b) with
| FStar_Parser_AST.Variable (_43_394) -> begin
(Prims.raise (FStar_Absyn_Syntax.Error (("Unexpected binder without annotation", b.FStar_Parser_AST.brange))))
end
| FStar_Parser_AST.TVariable (_43_397) -> begin
false
end
| FStar_Parser_AST.TAnnotated (_43_400) -> begin
true
end
| (FStar_Parser_AST.Annotated (_, t)) | (FStar_Parser_AST.NoName (t)) -> begin
(is_kind env t)
end)
end))

let sort_ftv = (fun ftv -> (let _109_92 = (FStar_Util.remove_dups (fun x y -> (x.FStar_Absyn_Syntax.idText = y.FStar_Absyn_Syntax.idText)) ftv)
in (FStar_All.pipe_left (FStar_Util.sort_with (fun x y -> (FStar_String.compare x.FStar_Absyn_Syntax.idText y.FStar_Absyn_Syntax.idText))) _109_92)))

let rec free_type_vars_b = (fun env binder -> (match (binder.FStar_Parser_AST.b) with
| FStar_Parser_AST.Variable (_43_416) -> begin
(env, [])
end
| FStar_Parser_AST.TVariable (x) -> begin
(let _43_423 = (FStar_Parser_DesugarEnv.push_local_tbinding env x)
in (match (_43_423) with
| (env, _43_422) -> begin
(env, (x)::[])
end))
end
| FStar_Parser_AST.Annotated (_43_425, term) -> begin
(let _109_99 = (free_type_vars env term)
in (env, _109_99))
end
| FStar_Parser_AST.TAnnotated (id, _43_431) -> begin
(let _43_437 = (FStar_Parser_DesugarEnv.push_local_tbinding env id)
in (match (_43_437) with
| (env, _43_436) -> begin
(env, [])
end))
end
| FStar_Parser_AST.NoName (t) -> begin
(let _109_100 = (free_type_vars env t)
in (env, _109_100))
end))
and free_type_vars = (fun env t -> (match ((let _109_103 = (unparen t)
in _109_103.FStar_Parser_AST.tm)) with
| FStar_Parser_AST.Tvar (a) -> begin
(match ((FStar_Parser_DesugarEnv.try_lookup_typ_var env a)) with
| None -> begin
(a)::[]
end
| _43_446 -> begin
[]
end)
end
| (FStar_Parser_AST.Wild) | (FStar_Parser_AST.Const (_)) | (FStar_Parser_AST.Var (_)) | (FStar_Parser_AST.Name (_)) -> begin
[]
end
| (FStar_Parser_AST.Requires (t, _)) | (FStar_Parser_AST.Ensures (t, _)) | (FStar_Parser_AST.Labeled (t, _, _)) | (FStar_Parser_AST.NamedTyp (_, t)) | (FStar_Parser_AST.Paren (t)) | (FStar_Parser_AST.Ascribed (t, _)) -> begin
(free_type_vars env t)
end
| FStar_Parser_AST.Construct (_43_482, ts) -> begin
(FStar_List.collect (fun _43_489 -> (match (_43_489) with
| (t, _43_488) -> begin
(free_type_vars env t)
end)) ts)
end
| FStar_Parser_AST.Op (_43_491, ts) -> begin
(FStar_List.collect (free_type_vars env) ts)
end
| FStar_Parser_AST.App (t1, t2, _43_498) -> begin
(let _109_106 = (free_type_vars env t1)
in (let _109_105 = (free_type_vars env t2)
in (FStar_List.append _109_106 _109_105)))
end
| FStar_Parser_AST.Refine (b, t) -> begin
(let _43_507 = (free_type_vars_b env b)
in (match (_43_507) with
| (env, f) -> begin
(let _109_107 = (free_type_vars env t)
in (FStar_List.append f _109_107))
end))
end
| (FStar_Parser_AST.Product (binders, body)) | (FStar_Parser_AST.Sum (binders, body)) -> begin
(let _43_523 = (FStar_List.fold_left (fun _43_516 binder -> (match (_43_516) with
| (env, free) -> begin
(let _43_520 = (free_type_vars_b env binder)
in (match (_43_520) with
| (env, f) -> begin
(env, (FStar_List.append f free))
end))
end)) (env, []) binders)
in (match (_43_523) with
| (env, free) -> begin
(let _109_110 = (free_type_vars env body)
in (FStar_List.append free _109_110))
end))
end
| FStar_Parser_AST.Project (t, _43_526) -> begin
(free_type_vars env t)
end
| (FStar_Parser_AST.Abs (_)) | (FStar_Parser_AST.If (_)) | (FStar_Parser_AST.QForall (_)) | (FStar_Parser_AST.QExists (_)) -> begin
[]
end
| (FStar_Parser_AST.Let (_)) | (FStar_Parser_AST.Record (_)) | (FStar_Parser_AST.Match (_)) | (FStar_Parser_AST.TryWith (_)) | (FStar_Parser_AST.Seq (_)) -> begin
(FStar_Parser_AST.error "Unexpected type in free_type_vars computation" t t.FStar_Parser_AST.range)
end))

let head_and_args = (fun t -> (let rec aux = (fun args t -> (match ((let _109_117 = (unparen t)
in _109_117.FStar_Parser_AST.tm)) with
| FStar_Parser_AST.App (t, arg, imp) -> begin
(aux (((arg, imp))::args) t)
end
| FStar_Parser_AST.Construct (l, args') -> begin
({FStar_Parser_AST.tm = FStar_Parser_AST.Name (l); FStar_Parser_AST.range = t.FStar_Parser_AST.range; FStar_Parser_AST.level = t.FStar_Parser_AST.level}, (FStar_List.append args' args))
end
| _43_570 -> begin
(t, args)
end))
in (aux [] t)))

let close = (fun env t -> (let ftv = (let _109_122 = (free_type_vars env t)
in (FStar_All.pipe_left sort_ftv _109_122))
in (match (((FStar_List.length ftv) = 0)) with
| true -> begin
t
end
| false -> begin
(let binders = (FStar_All.pipe_right ftv (FStar_List.map (fun x -> (let _109_126 = (let _109_125 = (let _109_124 = (kind_star x.FStar_Absyn_Syntax.idRange)
in (x, _109_124))
in FStar_Parser_AST.TAnnotated (_109_125))
in (FStar_Parser_AST.mk_binder _109_126 x.FStar_Absyn_Syntax.idRange FStar_Parser_AST.Type (Some (FStar_Absyn_Syntax.Implicit)))))))
in (let result = (FStar_Parser_AST.mk_term (FStar_Parser_AST.Product ((binders, t))) t.FStar_Parser_AST.range t.FStar_Parser_AST.level)
in result))
end)))

let close_fun = (fun env t -> (let ftv = (let _109_131 = (free_type_vars env t)
in (FStar_All.pipe_left sort_ftv _109_131))
in (match (((FStar_List.length ftv) = 0)) with
| true -> begin
t
end
| false -> begin
(let binders = (FStar_All.pipe_right ftv (FStar_List.map (fun x -> (let _109_135 = (let _109_134 = (let _109_133 = (kind_star x.FStar_Absyn_Syntax.idRange)
in (x, _109_133))
in FStar_Parser_AST.TAnnotated (_109_134))
in (FStar_Parser_AST.mk_binder _109_135 x.FStar_Absyn_Syntax.idRange FStar_Parser_AST.Type (Some (FStar_Absyn_Syntax.Implicit)))))))
in (let t = (match ((let _109_136 = (unlabel t)
in _109_136.FStar_Parser_AST.tm)) with
| FStar_Parser_AST.Product (_43_583) -> begin
t
end
| _43_586 -> begin
(FStar_Parser_AST.mk_term (FStar_Parser_AST.App (((FStar_Parser_AST.mk_term (FStar_Parser_AST.Name (FStar_Absyn_Const.effect_Tot_lid)) t.FStar_Parser_AST.range t.FStar_Parser_AST.level), t, FStar_Parser_AST.Nothing))) t.FStar_Parser_AST.range t.FStar_Parser_AST.level)
end)
in (let result = (FStar_Parser_AST.mk_term (FStar_Parser_AST.Product ((binders, t))) t.FStar_Parser_AST.range t.FStar_Parser_AST.level)
in result)))
end)))

let rec uncurry = (fun bs t -> (match (t.FStar_Parser_AST.tm) with
| FStar_Parser_AST.Product (binders, t) -> begin
(uncurry (FStar_List.append bs binders) t)
end
| _43_596 -> begin
(bs, t)
end))

let rec is_app_pattern = (fun p -> (match (p.FStar_Parser_AST.pat) with
| FStar_Parser_AST.PatAscribed (p, _43_600) -> begin
(is_app_pattern p)
end
| FStar_Parser_AST.PatApp ({FStar_Parser_AST.pat = FStar_Parser_AST.PatVar (_43_606); FStar_Parser_AST.prange = _43_604}, _43_610) -> begin
true
end
| _43_614 -> begin
false
end))

let rec destruct_app_pattern = (fun env is_top_level p -> (match (p.FStar_Parser_AST.pat) with
| FStar_Parser_AST.PatAscribed (p, t) -> begin
(let _43_626 = (destruct_app_pattern env is_top_level p)
in (match (_43_626) with
| (name, args, _43_625) -> begin
(name, args, Some (t))
end))
end
| FStar_Parser_AST.PatApp ({FStar_Parser_AST.pat = FStar_Parser_AST.PatVar (id, _43_631); FStar_Parser_AST.prange = _43_628}, args) when is_top_level -> begin
(let _109_150 = (let _109_149 = (FStar_Parser_DesugarEnv.qualify env id)
in FStar_Util.Inr (_109_149))
in (_109_150, args, None))
end
| FStar_Parser_AST.PatApp ({FStar_Parser_AST.pat = FStar_Parser_AST.PatVar (id, _43_642); FStar_Parser_AST.prange = _43_639}, args) -> begin
(FStar_Util.Inl (id), args, None)
end
| _43_650 -> begin
(FStar_All.failwith "Not an app pattern")
end))

type bnd =
| TBinder of (FStar_Absyn_Syntax.btvdef * FStar_Absyn_Syntax.knd * FStar_Absyn_Syntax.aqual)
| VBinder of (FStar_Absyn_Syntax.bvvdef * FStar_Absyn_Syntax.typ * FStar_Absyn_Syntax.aqual)
| LetBinder of (FStar_Absyn_Syntax.lident * FStar_Absyn_Syntax.typ)

let is_TBinder = (fun _discr_ -> (match (_discr_) with
| TBinder (_) -> begin
true
end
| _ -> begin
false
end))

let is_VBinder = (fun _discr_ -> (match (_discr_) with
| VBinder (_) -> begin
true
end
| _ -> begin
false
end))

let is_LetBinder = (fun _discr_ -> (match (_discr_) with
| LetBinder (_) -> begin
true
end
| _ -> begin
false
end))

let ___TBinder____0 = (fun projectee -> (match (projectee) with
| TBinder (_43_653) -> begin
_43_653
end))

let ___VBinder____0 = (fun projectee -> (match (projectee) with
| VBinder (_43_656) -> begin
_43_656
end))

let ___LetBinder____0 = (fun projectee -> (match (projectee) with
| LetBinder (_43_659) -> begin
_43_659
end))

let binder_of_bnd = (fun _43_3 -> (match (_43_3) with
| TBinder (a, k, aq) -> begin
(FStar_Util.Inl ((FStar_Absyn_Util.bvd_to_bvar_s a k)), aq)
end
| VBinder (x, t, aq) -> begin
(FStar_Util.Inr ((FStar_Absyn_Util.bvd_to_bvar_s x t)), aq)
end
| _43_672 -> begin
(FStar_All.failwith "Impossible")
end))

let as_binder = (fun env imp _43_4 -> (match (_43_4) with
| FStar_Util.Inl (None, k) -> begin
(let _109_201 = (FStar_Absyn_Syntax.null_t_binder k)
in (_109_201, env))
end
| FStar_Util.Inr (None, t) -> begin
(let _109_202 = (FStar_Absyn_Syntax.null_v_binder t)
in (_109_202, env))
end
| FStar_Util.Inl (Some (a), k) -> begin
(let _43_691 = (FStar_Parser_DesugarEnv.push_local_tbinding env a)
in (match (_43_691) with
| (env, a) -> begin
((FStar_Util.Inl ((FStar_Absyn_Util.bvd_to_bvar_s a k)), imp), env)
end))
end
| FStar_Util.Inr (Some (x), t) -> begin
(let _43_699 = (FStar_Parser_DesugarEnv.push_local_vbinding env x)
in (match (_43_699) with
| (env, x) -> begin
((FStar_Util.Inr ((FStar_Absyn_Util.bvd_to_bvar_s x t)), imp), env)
end))
end))

type env_t =
FStar_Parser_DesugarEnv.env

type lenv_t =
(FStar_Absyn_Syntax.btvdef, FStar_Absyn_Syntax.bvvdef) FStar_Util.either Prims.list

let label_conjuncts = (fun tag polarity label_opt f -> (let label = (fun f -> (let msg = (match (label_opt) with
| Some (l) -> begin
l
end
| _43_709 -> begin
(let _109_213 = (FStar_Range.string_of_range f.FStar_Parser_AST.range)
in (FStar_Util.format2 "%s at %s" tag _109_213))
end)
in (FStar_Parser_AST.mk_term (FStar_Parser_AST.Labeled ((f, msg, polarity))) f.FStar_Parser_AST.range f.FStar_Parser_AST.level)))
in (let rec aux = (fun f -> (match (f.FStar_Parser_AST.tm) with
| FStar_Parser_AST.Paren (g) -> begin
(let _109_217 = (let _109_216 = (aux g)
in FStar_Parser_AST.Paren (_109_216))
in (FStar_Parser_AST.mk_term _109_217 f.FStar_Parser_AST.range f.FStar_Parser_AST.level))
end
| FStar_Parser_AST.Op ("/\\", f1::f2::[]) -> begin
(let _109_223 = (let _109_222 = (let _109_221 = (let _109_220 = (aux f1)
in (let _109_219 = (let _109_218 = (aux f2)
in (_109_218)::[])
in (_109_220)::_109_219))
in ("/\\", _109_221))
in FStar_Parser_AST.Op (_109_222))
in (FStar_Parser_AST.mk_term _109_223 f.FStar_Parser_AST.range f.FStar_Parser_AST.level))
end
| FStar_Parser_AST.If (f1, f2, f3) -> begin
(let _109_227 = (let _109_226 = (let _109_225 = (aux f2)
in (let _109_224 = (aux f3)
in (f1, _109_225, _109_224)))
in FStar_Parser_AST.If (_109_226))
in (FStar_Parser_AST.mk_term _109_227 f.FStar_Parser_AST.range f.FStar_Parser_AST.level))
end
| FStar_Parser_AST.Abs (binders, g) -> begin
(let _109_230 = (let _109_229 = (let _109_228 = (aux g)
in (binders, _109_228))
in FStar_Parser_AST.Abs (_109_229))
in (FStar_Parser_AST.mk_term _109_230 f.FStar_Parser_AST.range f.FStar_Parser_AST.level))
end
| _43_731 -> begin
(label f)
end))
in (aux f))))

let mk_lb = (fun _43_735 -> (match (_43_735) with
| (n, t, e) -> begin
{FStar_Absyn_Syntax.lbname = n; FStar_Absyn_Syntax.lbtyp = t; FStar_Absyn_Syntax.lbeff = FStar_Absyn_Const.effect_ALL_lid; FStar_Absyn_Syntax.lbdef = e}
end))

let rec desugar_data_pat = (fun env p -> (let resolvex = (fun l e x -> (match ((FStar_All.pipe_right l (FStar_Util.find_opt (fun _43_5 -> (match (_43_5) with
| FStar_Util.Inr (y) -> begin
(y.FStar_Absyn_Syntax.ppname.FStar_Absyn_Syntax.idText = x.FStar_Absyn_Syntax.idText)
end
| _43_746 -> begin
false
end))))) with
| Some (FStar_Util.Inr (y)) -> begin
(l, e, y)
end
| _43_751 -> begin
(let _43_754 = (FStar_Parser_DesugarEnv.push_local_vbinding e x)
in (match (_43_754) with
| (e, x) -> begin
((FStar_Util.Inr (x))::l, e, x)
end))
end))
in (let resolvea = (fun l e a -> (match ((FStar_All.pipe_right l (FStar_Util.find_opt (fun _43_6 -> (match (_43_6) with
| FStar_Util.Inl (b) -> begin
(b.FStar_Absyn_Syntax.ppname.FStar_Absyn_Syntax.idText = a.FStar_Absyn_Syntax.idText)
end
| _43_763 -> begin
false
end))))) with
| Some (FStar_Util.Inl (b)) -> begin
(l, e, b)
end
| _43_768 -> begin
(let _43_771 = (FStar_Parser_DesugarEnv.push_local_tbinding e a)
in (match (_43_771) with
| (e, a) -> begin
((FStar_Util.Inl (a))::l, e, a)
end))
end))
in (let rec aux = (fun loc env p -> (let pos = (fun q -> (FStar_Absyn_Syntax.withinfo q None p.FStar_Parser_AST.prange))
in (let pos_r = (fun r q -> (FStar_Absyn_Syntax.withinfo q None r))
in (match (p.FStar_Parser_AST.pat) with
| FStar_Parser_AST.PatOr ([]) -> begin
(FStar_All.failwith "impossible")
end
| FStar_Parser_AST.PatOr (p::ps) -> begin
(let _43_793 = (aux loc env p)
in (match (_43_793) with
| (loc, env, var, p, _43_792) -> begin
(let _43_810 = (FStar_List.fold_left (fun _43_797 p -> (match (_43_797) with
| (loc, env, ps) -> begin
(let _43_806 = (aux loc env p)
in (match (_43_806) with
| (loc, env, _43_802, p, _43_805) -> begin
(loc, env, (p)::ps)
end))
end)) (loc, env, []) ps)
in (match (_43_810) with
| (loc, env, ps) -> begin
(let pat = (FStar_All.pipe_left pos (FStar_Absyn_Syntax.Pat_disj ((p)::(FStar_List.rev ps))))
in (let _43_812 = (let _109_302 = (FStar_Absyn_Syntax.pat_vars pat)
in (Prims.ignore _109_302))
in (loc, env, var, pat, false)))
end))
end))
end
| FStar_Parser_AST.PatAscribed (p, t) -> begin
(let p = (match ((is_kind env t)) with
| true -> begin
(match (p.FStar_Parser_AST.pat) with
| FStar_Parser_AST.PatTvar (_43_819) -> begin
p
end
| FStar_Parser_AST.PatVar (x, imp) -> begin
(let _43_825 = p
in {FStar_Parser_AST.pat = FStar_Parser_AST.PatTvar ((x, imp)); FStar_Parser_AST.prange = _43_825.FStar_Parser_AST.prange})
end
| _43_828 -> begin
(Prims.raise (FStar_Absyn_Syntax.Error (("Unexpected pattern", p.FStar_Parser_AST.prange))))
end)
end
| false -> begin
p
end)
in (let _43_835 = (aux loc env p)
in (match (_43_835) with
| (loc, env', binder, p, imp) -> begin
(let binder = (match (binder) with
| LetBinder (_43_837) -> begin
(FStar_All.failwith "impossible")
end
| TBinder (x, _43_841, aq) -> begin
(let _109_304 = (let _109_303 = (desugar_kind env t)
in (x, _109_303, aq))
in TBinder (_109_304))
end
| VBinder (x, _43_847, aq) -> begin
(let t = (close_fun env t)
in (let _109_306 = (let _109_305 = (desugar_typ env t)
in (x, _109_305, aq))
in VBinder (_109_306)))
end)
in (loc, env', binder, p, imp))
end)))
end
| FStar_Parser_AST.PatTvar (a, imp) -> begin
(let aq = (match (imp) with
| true -> begin
Some (FStar_Absyn_Syntax.Implicit)
end
| false -> begin
None
end)
in (match ((a.FStar_Absyn_Syntax.idText = "\'_")) with
| true -> begin
(let a = (FStar_All.pipe_left FStar_Absyn_Util.new_bvd (Some (p.FStar_Parser_AST.prange)))
in (let _109_307 = (FStar_All.pipe_left pos (FStar_Absyn_Syntax.Pat_twild ((FStar_Absyn_Util.bvd_to_bvar_s a FStar_Absyn_Syntax.kun))))
in (loc, env, TBinder ((a, FStar_Absyn_Syntax.kun, aq)), _109_307, imp)))
end
| false -> begin
(let _43_862 = (resolvea loc env a)
in (match (_43_862) with
| (loc, env, abvd) -> begin
(let _109_308 = (FStar_All.pipe_left pos (FStar_Absyn_Syntax.Pat_tvar ((FStar_Absyn_Util.bvd_to_bvar_s abvd FStar_Absyn_Syntax.kun))))
in (loc, env, TBinder ((abvd, FStar_Absyn_Syntax.kun, aq)), _109_308, imp))
end))
end))
end
| FStar_Parser_AST.PatWild -> begin
(let x = (FStar_Absyn_Util.new_bvd (Some (p.FStar_Parser_AST.prange)))
in (let y = (FStar_Absyn_Util.new_bvd (Some (p.FStar_Parser_AST.prange)))
in (let _109_309 = (FStar_All.pipe_left pos (FStar_Absyn_Syntax.Pat_wild ((FStar_Absyn_Util.bvd_to_bvar_s y FStar_Absyn_Syntax.tun))))
in (loc, env, VBinder ((x, FStar_Absyn_Syntax.tun, None)), _109_309, false))))
end
| FStar_Parser_AST.PatConst (c) -> begin
(let x = (FStar_Absyn_Util.new_bvd (Some (p.FStar_Parser_AST.prange)))
in (let _109_310 = (FStar_All.pipe_left pos (FStar_Absyn_Syntax.Pat_constant (c)))
in (loc, env, VBinder ((x, FStar_Absyn_Syntax.tun, None)), _109_310, false)))
end
| FStar_Parser_AST.PatVar (x, imp) -> begin
(let aq = (match (imp) with
| true -> begin
Some (FStar_Absyn_Syntax.Implicit)
end
| false -> begin
None
end)
in (let _43_877 = (resolvex loc env x)
in (match (_43_877) with
| (loc, env, xbvd) -> begin
(let _109_311 = (FStar_All.pipe_left pos (FStar_Absyn_Syntax.Pat_var ((FStar_Absyn_Util.bvd_to_bvar_s xbvd FStar_Absyn_Syntax.tun))))
in (loc, env, VBinder ((xbvd, FStar_Absyn_Syntax.tun, aq)), _109_311, imp))
end)))
end
| FStar_Parser_AST.PatName (l) -> begin
(let l = (FStar_Parser_DesugarEnv.fail_or env (FStar_Parser_DesugarEnv.try_lookup_datacon env) l)
in (let x = (FStar_Absyn_Util.new_bvd (Some (p.FStar_Parser_AST.prange)))
in (let _109_312 = (FStar_All.pipe_left pos (FStar_Absyn_Syntax.Pat_cons ((l, Some (FStar_Absyn_Syntax.Data_ctor), []))))
in (loc, env, VBinder ((x, FStar_Absyn_Syntax.tun, None)), _109_312, false))))
end
| FStar_Parser_AST.PatApp ({FStar_Parser_AST.pat = FStar_Parser_AST.PatName (l); FStar_Parser_AST.prange = _43_883}, args) -> begin
(let _43_905 = (FStar_List.fold_right (fun arg _43_894 -> (match (_43_894) with
| (loc, env, args) -> begin
(let _43_901 = (aux loc env arg)
in (match (_43_901) with
| (loc, env, _43_898, arg, imp) -> begin
(loc, env, ((arg, imp))::args)
end))
end)) args (loc, env, []))
in (match (_43_905) with
| (loc, env, args) -> begin
(let l = (FStar_Parser_DesugarEnv.fail_or env (FStar_Parser_DesugarEnv.try_lookup_datacon env) l)
in (let x = (FStar_Absyn_Util.new_bvd (Some (p.FStar_Parser_AST.prange)))
in (let _109_315 = (FStar_All.pipe_left pos (FStar_Absyn_Syntax.Pat_cons ((l, Some (FStar_Absyn_Syntax.Data_ctor), args))))
in (loc, env, VBinder ((x, FStar_Absyn_Syntax.tun, None)), _109_315, false))))
end))
end
| FStar_Parser_AST.PatApp (_43_909) -> begin
(Prims.raise (FStar_Absyn_Syntax.Error (("Unexpected pattern", p.FStar_Parser_AST.prange))))
end
| FStar_Parser_AST.PatList (pats) -> begin
(let _43_929 = (FStar_List.fold_right (fun pat _43_917 -> (match (_43_917) with
| (loc, env, pats) -> begin
(let _43_925 = (aux loc env pat)
in (match (_43_925) with
| (loc, env, _43_921, pat, _43_924) -> begin
(loc, env, (pat)::pats)
end))
end)) pats (loc, env, []))
in (match (_43_929) with
| (loc, env, pats) -> begin
(let pat = (let _109_328 = (let _109_327 = (let _109_323 = (FStar_Range.end_range p.FStar_Parser_AST.prange)
in (pos_r _109_323))
in (let _109_326 = (let _109_325 = (let _109_324 = (FStar_Absyn_Util.fv FStar_Absyn_Const.nil_lid)
in (_109_324, Some (FStar_Absyn_Syntax.Data_ctor), []))
in FStar_Absyn_Syntax.Pat_cons (_109_325))
in (FStar_All.pipe_left _109_327 _109_326)))
in (FStar_List.fold_right (fun hd tl -> (let r = (FStar_Range.union_ranges hd.FStar_Absyn_Syntax.p tl.FStar_Absyn_Syntax.p)
in (let _109_322 = (let _109_321 = (let _109_320 = (FStar_Absyn_Util.fv FStar_Absyn_Const.cons_lid)
in (_109_320, Some (FStar_Absyn_Syntax.Data_ctor), ((hd, false))::((tl, false))::[]))
in FStar_Absyn_Syntax.Pat_cons (_109_321))
in (FStar_All.pipe_left (pos_r r) _109_322)))) pats _109_328))
in (let x = (FStar_Absyn_Util.new_bvd (Some (p.FStar_Parser_AST.prange)))
in (loc, env, VBinder ((x, FStar_Absyn_Syntax.tun, None)), pat, false)))
end))
end
| FStar_Parser_AST.PatTuple (args, dep) -> begin
(let _43_955 = (FStar_List.fold_left (fun _43_942 p -> (match (_43_942) with
| (loc, env, pats) -> begin
(let _43_951 = (aux loc env p)
in (match (_43_951) with
| (loc, env, _43_947, pat, _43_950) -> begin
(loc, env, ((pat, false))::pats)
end))
end)) (loc, env, []) args)
in (match (_43_955) with
| (loc, env, args) -> begin
(let args = (FStar_List.rev args)
in (let l = (match (dep) with
| true -> begin
(FStar_Absyn_Util.mk_dtuple_data_lid (FStar_List.length args) p.FStar_Parser_AST.prange)
end
| false -> begin
(FStar_Absyn_Util.mk_tuple_data_lid (FStar_List.length args) p.FStar_Parser_AST.prange)
end)
in (let constr = (FStar_Parser_DesugarEnv.fail_or env (FStar_Parser_DesugarEnv.try_lookup_lid env) l)
in (let l = (match (constr.FStar_Absyn_Syntax.n) with
| FStar_Absyn_Syntax.Exp_fvar (v, _43_961) -> begin
v
end
| _43_965 -> begin
(FStar_All.failwith "impossible")
end)
in (let x = (FStar_Absyn_Util.new_bvd (Some (p.FStar_Parser_AST.prange)))
in (let _109_331 = (FStar_All.pipe_left pos (FStar_Absyn_Syntax.Pat_cons ((l, Some (FStar_Absyn_Syntax.Data_ctor), args))))
in (loc, env, VBinder ((x, FStar_Absyn_Syntax.tun, None)), _109_331, false)))))))
end))
end
| FStar_Parser_AST.PatRecord ([]) -> begin
(Prims.raise (FStar_Absyn_Syntax.Error (("Unexpected pattern", p.FStar_Parser_AST.prange))))
end
| FStar_Parser_AST.PatRecord (fields) -> begin
(let _43_975 = (FStar_List.hd fields)
in (match (_43_975) with
| (f, _43_974) -> begin
(let _43_979 = (FStar_Parser_DesugarEnv.fail_or env (FStar_Parser_DesugarEnv.try_lookup_record_by_field_name env) f)
in (match (_43_979) with
| (record, _43_978) -> begin
(let fields = (FStar_All.pipe_right fields (FStar_List.map (fun _43_982 -> (match (_43_982) with
| (f, p) -> begin
(let _109_333 = (FStar_Parser_DesugarEnv.fail_or env (FStar_Parser_DesugarEnv.qualify_field_to_record env record) f)
in (_109_333, p))
end))))
in (let args = (FStar_All.pipe_right record.FStar_Parser_DesugarEnv.fields (FStar_List.map (fun _43_987 -> (match (_43_987) with
| (f, _43_986) -> begin
(match ((FStar_All.pipe_right fields (FStar_List.tryFind (fun _43_991 -> (match (_43_991) with
| (g, _43_990) -> begin
(FStar_Absyn_Syntax.lid_equals f g)
end))))) with
| None -> begin
(FStar_Parser_AST.mk_pattern FStar_Parser_AST.PatWild p.FStar_Parser_AST.prange)
end
| Some (_43_994, p) -> begin
p
end)
end))))
in (let app = (FStar_Parser_AST.mk_pattern (FStar_Parser_AST.PatApp (((FStar_Parser_AST.mk_pattern (FStar_Parser_AST.PatName (record.FStar_Parser_DesugarEnv.constrname)) p.FStar_Parser_AST.prange), args))) p.FStar_Parser_AST.prange)
in (let _43_1006 = (aux loc env app)
in (match (_43_1006) with
| (env, e, b, p, _43_1005) -> begin
(let p = (match (p.FStar_Absyn_Syntax.v) with
| FStar_Absyn_Syntax.Pat_cons (fv, _43_1009, args) -> begin
(let _109_341 = (let _109_340 = (let _109_339 = (let _109_338 = (let _109_337 = (let _109_336 = (FStar_All.pipe_right record.FStar_Parser_DesugarEnv.fields (FStar_List.map Prims.fst))
in (record.FStar_Parser_DesugarEnv.typename, _109_336))
in FStar_Absyn_Syntax.Record_ctor (_109_337))
in Some (_109_338))
in (fv, _109_339, args))
in FStar_Absyn_Syntax.Pat_cons (_109_340))
in (FStar_All.pipe_left pos _109_341))
end
| _43_1014 -> begin
p
end)
in (env, e, b, p, false))
end)))))
end))
end))
end))))
in (let _43_1023 = (aux [] env p)
in (match (_43_1023) with
| (_43_1017, env, b, p, _43_1022) -> begin
(env, b, p)
end))))))
and desugar_binding_pat_maybe_top = (fun top env p -> (match (top) with
| true -> begin
(match (p.FStar_Parser_AST.pat) with
| FStar_Parser_AST.PatVar (x, _43_1029) -> begin
(let _109_347 = (let _109_346 = (let _109_345 = (FStar_Parser_DesugarEnv.qualify env x)
in (_109_345, FStar_Absyn_Syntax.tun))
in LetBinder (_109_346))
in (env, _109_347, None))
end
| FStar_Parser_AST.PatAscribed ({FStar_Parser_AST.pat = FStar_Parser_AST.PatVar (x, _43_1036); FStar_Parser_AST.prange = _43_1033}, t) -> begin
(let _109_351 = (let _109_350 = (let _109_349 = (FStar_Parser_DesugarEnv.qualify env x)
in (let _109_348 = (desugar_typ env t)
in (_109_349, _109_348)))
in LetBinder (_109_350))
in (env, _109_351, None))
end
| _43_1044 -> begin
(Prims.raise (FStar_Absyn_Syntax.Error (("Unexpected pattern at the top-level", p.FStar_Parser_AST.prange))))
end)
end
| false -> begin
(let _43_1048 = (desugar_data_pat env p)
in (match (_43_1048) with
| (env, binder, p) -> begin
(let p = (match (p.FStar_Absyn_Syntax.v) with
| (FStar_Absyn_Syntax.Pat_var (_)) | (FStar_Absyn_Syntax.Pat_tvar (_)) | (FStar_Absyn_Syntax.Pat_wild (_)) -> begin
None
end
| _43_1059 -> begin
Some (p)
end)
in (env, binder, p))
end))
end))
and desugar_binding_pat = (fun env p -> (desugar_binding_pat_maybe_top false env p))
and desugar_match_pat_maybe_top = (fun _43_1063 env pat -> (let _43_1071 = (desugar_data_pat env pat)
in (match (_43_1071) with
| (env, _43_1069, pat) -> begin
(env, pat)
end)))
and desugar_match_pat = (fun env p -> (desugar_match_pat_maybe_top false env p))
and desugar_typ_or_exp = (fun env t -> (match ((is_type env t)) with
| true -> begin
(let _109_361 = (desugar_typ env t)
in FStar_Util.Inl (_109_361))
end
| false -> begin
(let _109_362 = (desugar_exp env t)
in FStar_Util.Inr (_109_362))
end))
and desugar_exp = (fun env e -> (desugar_exp_maybe_top false env e))
and desugar_exp_maybe_top = (fun top_level env top -> (let pos = (fun e -> (e None top.FStar_Parser_AST.range))
in (let setpos = (fun e -> (let _43_1085 = e
in {FStar_Absyn_Syntax.n = _43_1085.FStar_Absyn_Syntax.n; FStar_Absyn_Syntax.tk = _43_1085.FStar_Absyn_Syntax.tk; FStar_Absyn_Syntax.pos = top.FStar_Parser_AST.range; FStar_Absyn_Syntax.fvs = _43_1085.FStar_Absyn_Syntax.fvs; FStar_Absyn_Syntax.uvs = _43_1085.FStar_Absyn_Syntax.uvs}))
in (match ((let _109_382 = (unparen top)
in _109_382.FStar_Parser_AST.tm)) with
| FStar_Parser_AST.Const (c) -> begin
(FStar_All.pipe_left pos (FStar_Absyn_Syntax.mk_Exp_constant c))
end
| FStar_Parser_AST.Op (s, args) -> begin
(match ((op_as_vlid env (FStar_List.length args) top.FStar_Parser_AST.range s)) with
| None -> begin
(Prims.raise (FStar_Absyn_Syntax.Error (((Prims.strcat "Unexpected operator: " s), top.FStar_Parser_AST.range))))
end
| Some (l) -> begin
(let op = (let _109_385 = (FStar_Absyn_Syntax.range_of_lid l)
in (FStar_Absyn_Util.fvar None l _109_385))
in (let args = (FStar_All.pipe_right args (FStar_List.map (fun t -> (let _109_387 = (desugar_typ_or_exp env t)
in (_109_387, None)))))
in (let _109_388 = (FStar_Absyn_Util.mk_exp_app op args)
in (FStar_All.pipe_left setpos _109_388))))
end)
end
| (FStar_Parser_AST.Var (l)) | (FStar_Parser_AST.Name (l)) -> begin
(match ((l.FStar_Absyn_Syntax.str = "ref")) with
| true -> begin
(match ((FStar_Parser_DesugarEnv.try_lookup_lid env FStar_Absyn_Const.alloc_lid)) with
| None -> begin
(let _109_391 = (let _109_390 = (let _109_389 = (FStar_Absyn_Syntax.range_of_lid l)
in ("Identifier \'ref\' not found; include lib/st.fst in your path", _109_389))
in FStar_Absyn_Syntax.Error (_109_390))
in (Prims.raise _109_391))
end
| Some (e) -> begin
(setpos e)
end)
end
| false -> begin
(let _109_392 = (FStar_Parser_DesugarEnv.fail_or env (FStar_Parser_DesugarEnv.try_lookup_lid env) l)
in (FStar_All.pipe_left setpos _109_392))
end)
end
| FStar_Parser_AST.Construct (l, args) -> begin
(let dt = (let _109_397 = (let _109_396 = (let _109_395 = (FStar_Parser_DesugarEnv.fail_or env (FStar_Parser_DesugarEnv.try_lookup_datacon env) l)
in (_109_395, Some (FStar_Absyn_Syntax.Data_ctor)))
in (FStar_Absyn_Syntax.mk_Exp_fvar _109_396))
in (FStar_All.pipe_left pos _109_397))
in (match (args) with
| [] -> begin
dt
end
| _43_1112 -> begin
(let args = (FStar_List.map (fun _43_1115 -> (match (_43_1115) with
| (t, imp) -> begin
(let te = (desugar_typ_or_exp env t)
in (arg_withimp_e imp te))
end)) args)
in (let _109_402 = (let _109_401 = (let _109_400 = (let _109_399 = (FStar_Absyn_Util.mk_exp_app dt args)
in (_109_399, FStar_Absyn_Syntax.Data_app))
in FStar_Absyn_Syntax.Meta_desugared (_109_400))
in (FStar_Absyn_Syntax.mk_Exp_meta _109_401))
in (FStar_All.pipe_left setpos _109_402)))
end))
end
| FStar_Parser_AST.Abs (binders, body) -> begin
(let _43_1152 = (FStar_List.fold_left (fun _43_1124 pat -> (match (_43_1124) with
| (env, ftvs) -> begin
(match (pat.FStar_Parser_AST.pat) with
| FStar_Parser_AST.PatAscribed ({FStar_Parser_AST.pat = FStar_Parser_AST.PatTvar (a, imp); FStar_Parser_AST.prange = _43_1127}, t) -> begin
(let ftvs = (let _109_405 = (free_type_vars env t)
in (FStar_List.append _109_405 ftvs))
in (let _109_407 = (let _109_406 = (FStar_Parser_DesugarEnv.push_local_tbinding env a)
in (FStar_All.pipe_left Prims.fst _109_406))
in (_109_407, ftvs)))
end
| FStar_Parser_AST.PatTvar (a, _43_1139) -> begin
(let _109_409 = (let _109_408 = (FStar_Parser_DesugarEnv.push_local_tbinding env a)
in (FStar_All.pipe_left Prims.fst _109_408))
in (_109_409, ftvs))
end
| FStar_Parser_AST.PatAscribed (_43_1143, t) -> begin
(let _109_411 = (let _109_410 = (free_type_vars env t)
in (FStar_List.append _109_410 ftvs))
in (env, _109_411))
end
| _43_1148 -> begin
(env, ftvs)
end)
end)) (env, []) binders)
in (match (_43_1152) with
| (_43_1150, ftv) -> begin
(let ftv = (sort_ftv ftv)
in (let binders = (let _109_413 = (FStar_All.pipe_right ftv (FStar_List.map (fun a -> (FStar_Parser_AST.mk_pattern (FStar_Parser_AST.PatTvar ((a, true))) top.FStar_Parser_AST.range))))
in (FStar_List.append _109_413 binders))
in (let rec aux = (fun env bs sc_pat_opt _43_7 -> (match (_43_7) with
| [] -> begin
(let body = (desugar_exp env body)
in (let body = (match (sc_pat_opt) with
| Some (sc, pat) -> begin
(FStar_Absyn_Syntax.mk_Exp_match (sc, ((pat, None, body))::[]) None body.FStar_Absyn_Syntax.pos)
end
| None -> begin
body
end)
in (FStar_Absyn_Syntax.mk_Exp_abs' ((FStar_List.rev bs), body) None top.FStar_Parser_AST.range)))
end
| p::rest -> begin
(let _43_1175 = (desugar_binding_pat env p)
in (match (_43_1175) with
| (env, b, pat) -> begin
(let _43_1235 = (match (b) with
| LetBinder (_43_1177) -> begin
(FStar_All.failwith "Impossible")
end
| TBinder (a, k, aq) -> begin
(let _109_422 = (binder_of_bnd b)
in (_109_422, sc_pat_opt))
end
| VBinder (x, t, aq) -> begin
(let b = (FStar_Absyn_Util.bvd_to_bvar_s x t)
in (let sc_pat_opt = (match ((pat, sc_pat_opt)) with
| (None, _43_1192) -> begin
sc_pat_opt
end
| (Some (p), None) -> begin
(let _109_424 = (let _109_423 = (FStar_Absyn_Util.bvar_to_exp b)
in (_109_423, p))
in Some (_109_424))
end
| (Some (p), Some (sc, p')) -> begin
(match ((sc.FStar_Absyn_Syntax.n, p'.FStar_Absyn_Syntax.v)) with
| (FStar_Absyn_Syntax.Exp_bvar (_43_1206), _43_1209) -> begin
(let tup = (FStar_Absyn_Util.mk_tuple_data_lid 2 top.FStar_Parser_AST.range)
in (let sc = (let _109_431 = (let _109_430 = (FStar_Absyn_Util.fvar (Some (FStar_Absyn_Syntax.Data_ctor)) tup top.FStar_Parser_AST.range)
in (let _109_429 = (let _109_428 = (FStar_Absyn_Syntax.varg sc)
in (let _109_427 = (let _109_426 = (let _109_425 = (FStar_Absyn_Util.bvar_to_exp b)
in (FStar_All.pipe_left FStar_Absyn_Syntax.varg _109_425))
in (_109_426)::[])
in (_109_428)::_109_427))
in (_109_430, _109_429)))
in (FStar_Absyn_Syntax.mk_Exp_app _109_431 None top.FStar_Parser_AST.range))
in (let p = (let _109_435 = (let _109_433 = (let _109_432 = (FStar_Absyn_Util.fv tup)
in (_109_432, Some (FStar_Absyn_Syntax.Data_ctor), ((p', false))::((p, false))::[]))
in FStar_Absyn_Syntax.Pat_cons (_109_433))
in (let _109_434 = (FStar_Range.union_ranges p'.FStar_Absyn_Syntax.p p.FStar_Absyn_Syntax.p)
in (FStar_Absyn_Util.withinfo _109_435 None _109_434)))
in Some ((sc, p)))))
end
| (FStar_Absyn_Syntax.Exp_app (_43_1215, args), FStar_Absyn_Syntax.Pat_cons (_43_1220, _43_1222, pats)) -> begin
(let tup = (FStar_Absyn_Util.mk_tuple_data_lid (1 + (FStar_List.length args)) top.FStar_Parser_AST.range)
in (let sc = (let _109_441 = (let _109_440 = (FStar_Absyn_Util.fvar (Some (FStar_Absyn_Syntax.Data_ctor)) tup top.FStar_Parser_AST.range)
in (let _109_439 = (let _109_438 = (let _109_437 = (let _109_436 = (FStar_Absyn_Util.bvar_to_exp b)
in (FStar_All.pipe_left FStar_Absyn_Syntax.varg _109_436))
in (_109_437)::[])
in (FStar_List.append args _109_438))
in (_109_440, _109_439)))
in (FStar_Absyn_Syntax.mk_Exp_app _109_441 None top.FStar_Parser_AST.range))
in (let p = (let _109_445 = (let _109_443 = (let _109_442 = (FStar_Absyn_Util.fv tup)
in (_109_442, Some (FStar_Absyn_Syntax.Data_ctor), (FStar_List.append pats (((p, false))::[]))))
in FStar_Absyn_Syntax.Pat_cons (_109_443))
in (let _109_444 = (FStar_Range.union_ranges p'.FStar_Absyn_Syntax.p p.FStar_Absyn_Syntax.p)
in (FStar_Absyn_Util.withinfo _109_445 None _109_444)))
in Some ((sc, p)))))
end
| _43_1231 -> begin
(FStar_All.failwith "Impossible")
end)
end)
in ((FStar_Util.Inr (b), aq), sc_pat_opt)))
end)
in (match (_43_1235) with
| (b, sc_pat_opt) -> begin
(aux env ((b)::bs) sc_pat_opt rest)
end))
end))
end))
in (aux env [] None binders))))
end))
end
| FStar_Parser_AST.App ({FStar_Parser_AST.tm = FStar_Parser_AST.Var (a); FStar_Parser_AST.range = _43_1239; FStar_Parser_AST.level = _43_1237}, arg, _43_1245) when ((FStar_Absyn_Syntax.lid_equals a FStar_Absyn_Const.assert_lid) || (FStar_Absyn_Syntax.lid_equals a FStar_Absyn_Const.assume_lid)) -> begin
(let phi = (desugar_formula env arg)
in (let _109_456 = (let _109_455 = (let _109_454 = (let _109_448 = (FStar_Absyn_Syntax.range_of_lid a)
in (FStar_Absyn_Util.fvar None a _109_448))
in (let _109_453 = (let _109_452 = (FStar_All.pipe_left FStar_Absyn_Syntax.targ phi)
in (let _109_451 = (let _109_450 = (let _109_449 = (FStar_Absyn_Syntax.mk_Exp_constant FStar_Absyn_Syntax.Const_unit None top.FStar_Parser_AST.range)
in (FStar_All.pipe_left FStar_Absyn_Syntax.varg _109_449))
in (_109_450)::[])
in (_109_452)::_109_451))
in (_109_454, _109_453)))
in (FStar_Absyn_Syntax.mk_Exp_app _109_455))
in (FStar_All.pipe_left pos _109_456)))
end
| FStar_Parser_AST.App (_43_1250) -> begin
(let rec aux = (fun args e -> (match ((let _109_461 = (unparen e)
in _109_461.FStar_Parser_AST.tm)) with
| FStar_Parser_AST.App (e, t, imp) -> begin
(let arg = (let _109_462 = (desugar_typ_or_exp env t)
in (FStar_All.pipe_left (arg_withimp_e imp) _109_462))
in (aux ((arg)::args) e))
end
| _43_1262 -> begin
(let head = (desugar_exp env e)
in (FStar_All.pipe_left pos (FStar_Absyn_Syntax.mk_Exp_app (head, args))))
end))
in (aux [] top))
end
| FStar_Parser_AST.Seq (t1, t2) -> begin
(let _109_468 = (let _109_467 = (let _109_466 = (let _109_465 = (desugar_exp env (FStar_Parser_AST.mk_term (FStar_Parser_AST.Let ((false, (((FStar_Parser_AST.mk_pattern FStar_Parser_AST.PatWild t1.FStar_Parser_AST.range), t1))::[], t2))) top.FStar_Parser_AST.range FStar_Parser_AST.Expr))
in (_109_465, FStar_Absyn_Syntax.Sequence))
in FStar_Absyn_Syntax.Meta_desugared (_109_466))
in (FStar_Absyn_Syntax.mk_Exp_meta _109_467))
in (FStar_All.pipe_left setpos _109_468))
end
| FStar_Parser_AST.Let (is_rec, (pat, _snd)::_tl, body) -> begin
(let ds_let_rec = (fun _43_1278 -> (match (()) with
| () -> begin
(let bindings = ((pat, _snd))::_tl
in (let funs = (FStar_All.pipe_right bindings (FStar_List.map (fun _43_1282 -> (match (_43_1282) with
| (p, def) -> begin
(match ((is_app_pattern p)) with
| true -> begin
(let _109_472 = (destruct_app_pattern env top_level p)
in (_109_472, def))
end
| false -> begin
(match ((FStar_Parser_AST.un_function p def)) with
| Some (p, def) -> begin
(let _109_473 = (destruct_app_pattern env top_level p)
in (_109_473, def))
end
| _43_1288 -> begin
(match (p.FStar_Parser_AST.pat) with
| FStar_Parser_AST.PatAscribed ({FStar_Parser_AST.pat = FStar_Parser_AST.PatVar (id, _43_1293); FStar_Parser_AST.prange = _43_1290}, t) -> begin
(match (top_level) with
| true -> begin
(let _109_476 = (let _109_475 = (let _109_474 = (FStar_Parser_DesugarEnv.qualify env id)
in FStar_Util.Inr (_109_474))
in (_109_475, [], Some (t)))
in (_109_476, def))
end
| false -> begin
((FStar_Util.Inl (id), [], Some (t)), def)
end)
end
| FStar_Parser_AST.PatVar (id, _43_1302) -> begin
(match (top_level) with
| true -> begin
(let _109_479 = (let _109_478 = (let _109_477 = (FStar_Parser_DesugarEnv.qualify env id)
in FStar_Util.Inr (_109_477))
in (_109_478, [], None))
in (_109_479, def))
end
| false -> begin
((FStar_Util.Inl (id), [], None), def)
end)
end
| _43_1306 -> begin
(Prims.raise (FStar_Absyn_Syntax.Error (("Unexpected let binding", p.FStar_Parser_AST.prange))))
end)
end)
end)
end))))
in (let _43_1332 = (FStar_List.fold_left (fun _43_1310 _43_1319 -> (match ((_43_1310, _43_1319)) with
| ((env, fnames), ((f, _43_1313, _43_1315), _43_1318)) -> begin
(let _43_1329 = (match (f) with
| FStar_Util.Inl (x) -> begin
(let _43_1324 = (FStar_Parser_DesugarEnv.push_local_vbinding env x)
in (match (_43_1324) with
| (env, xx) -> begin
(env, FStar_Util.Inl (xx))
end))
end
| FStar_Util.Inr (l) -> begin
(let _109_482 = (FStar_Parser_DesugarEnv.push_rec_binding env (FStar_Parser_DesugarEnv.Binding_let (l)))
in (_109_482, FStar_Util.Inr (l)))
end)
in (match (_43_1329) with
| (env, lbname) -> begin
(env, (lbname)::fnames)
end))
end)) (env, []) funs)
in (match (_43_1332) with
| (env', fnames) -> begin
(let fnames = (FStar_List.rev fnames)
in (let desugar_one_def = (fun env lbname _43_1343 -> (match (_43_1343) with
| ((_43_1338, args, result_t), def) -> begin
(let def = (match (result_t) with
| None -> begin
def
end
| Some (t) -> begin
(let _109_489 = (FStar_Range.union_ranges t.FStar_Parser_AST.range def.FStar_Parser_AST.range)
in (FStar_Parser_AST.mk_term (FStar_Parser_AST.Ascribed ((def, t))) _109_489 FStar_Parser_AST.Expr))
end)
in (let def = (match (args) with
| [] -> begin
def
end
| _43_1350 -> begin
(FStar_Parser_AST.mk_term (FStar_Parser_AST.un_curry_abs args def) top.FStar_Parser_AST.range top.FStar_Parser_AST.level)
end)
in (let body = (desugar_exp env def)
in (mk_lb (lbname, FStar_Absyn_Syntax.tun, body)))))
end))
in (let lbs = (FStar_List.map2 (desugar_one_def (match (is_rec) with
| true -> begin
env'
end
| false -> begin
env
end)) fnames funs)
in (let body = (desugar_exp env' body)
in (FStar_All.pipe_left pos (FStar_Absyn_Syntax.mk_Exp_let ((is_rec, lbs), body)))))))
end))))
end))
in (let ds_non_rec = (fun pat t1 t2 -> (let t1 = (desugar_exp env t1)
in (let _43_1363 = (desugar_binding_pat_maybe_top top_level env pat)
in (match (_43_1363) with
| (env, binder, pat) -> begin
(match (binder) with
| TBinder (_43_1365) -> begin
(FStar_All.failwith "Unexpected type binder in let")
end
| LetBinder (l, t) -> begin
(let body = (desugar_exp env t2)
in (FStar_All.pipe_left pos (FStar_Absyn_Syntax.mk_Exp_let ((false, ({FStar_Absyn_Syntax.lbname = FStar_Util.Inr (l); FStar_Absyn_Syntax.lbtyp = t; FStar_Absyn_Syntax.lbeff = FStar_Absyn_Const.effect_ALL_lid; FStar_Absyn_Syntax.lbdef = t1})::[]), body))))
end
| VBinder (x, t, _43_1375) -> begin
(let body = (desugar_exp env t2)
in (let body = (match (pat) with
| (None) | (Some ({FStar_Absyn_Syntax.v = FStar_Absyn_Syntax.Pat_wild (_); FStar_Absyn_Syntax.sort = _; FStar_Absyn_Syntax.p = _})) -> begin
body
end
| Some (pat) -> begin
(let _109_501 = (let _109_500 = (FStar_Absyn_Util.bvd_to_exp x t)
in (_109_500, ((pat, None, body))::[]))
in (FStar_Absyn_Syntax.mk_Exp_match _109_501 None body.FStar_Absyn_Syntax.pos))
end)
in (FStar_All.pipe_left pos (FStar_Absyn_Syntax.mk_Exp_let ((false, ((mk_lb (FStar_Util.Inl (x), t, t1)))::[]), body)))))
end)
end))))
in (match ((is_rec || (is_app_pattern pat))) with
| true -> begin
(ds_let_rec ())
end
| false -> begin
(ds_non_rec pat _snd body)
end)))
end
| FStar_Parser_AST.If (t1, t2, t3) -> begin
(let _109_514 = (let _109_513 = (let _109_512 = (desugar_exp env t1)
in (let _109_511 = (let _109_510 = (let _109_506 = (desugar_exp env t2)
in ((FStar_Absyn_Util.withinfo (FStar_Absyn_Syntax.Pat_constant (FStar_Absyn_Syntax.Const_bool (true))) None t2.FStar_Parser_AST.range), None, _109_506))
in (let _109_509 = (let _109_508 = (let _109_507 = (desugar_exp env t3)
in ((FStar_Absyn_Util.withinfo (FStar_Absyn_Syntax.Pat_constant (FStar_Absyn_Syntax.Const_bool (false))) None t3.FStar_Parser_AST.range), None, _109_507))
in (_109_508)::[])
in (_109_510)::_109_509))
in (_109_512, _109_511)))
in (FStar_Absyn_Syntax.mk_Exp_match _109_513))
in (FStar_All.pipe_left pos _109_514))
end
| FStar_Parser_AST.TryWith (e, branches) -> begin
(let r = top.FStar_Parser_AST.range
in (let handler = (FStar_Parser_AST.mk_function branches r r)
in (let body = (FStar_Parser_AST.mk_function ((((FStar_Parser_AST.mk_pattern (FStar_Parser_AST.PatConst (FStar_Absyn_Syntax.Const_unit)) r), None, e))::[]) r r)
in (let a1 = (FStar_Parser_AST.mk_term (FStar_Parser_AST.App (((FStar_Parser_AST.mk_term (FStar_Parser_AST.Var (FStar_Absyn_Const.try_with_lid)) r top.FStar_Parser_AST.level), body, FStar_Parser_AST.Nothing))) r top.FStar_Parser_AST.level)
in (let a2 = (FStar_Parser_AST.mk_term (FStar_Parser_AST.App ((a1, handler, FStar_Parser_AST.Nothing))) r top.FStar_Parser_AST.level)
in (desugar_exp env a2))))))
end
| FStar_Parser_AST.Match (e, branches) -> begin
(let desugar_branch = (fun _43_1414 -> (match (_43_1414) with
| (pat, wopt, b) -> begin
(let _43_1417 = (desugar_match_pat env pat)
in (match (_43_1417) with
| (env, pat) -> begin
(let wopt = (match (wopt) with
| None -> begin
None
end
| Some (e) -> begin
(let _109_517 = (desugar_exp env e)
in Some (_109_517))
end)
in (let b = (desugar_exp env b)
in (pat, wopt, b)))
end))
end))
in (let _109_523 = (let _109_522 = (let _109_521 = (desugar_exp env e)
in (let _109_520 = (FStar_List.map desugar_branch branches)
in (_109_521, _109_520)))
in (FStar_Absyn_Syntax.mk_Exp_match _109_522))
in (FStar_All.pipe_left pos _109_523)))
end
| FStar_Parser_AST.Ascribed (e, t) -> begin
(let _109_529 = (let _109_528 = (let _109_527 = (desugar_exp env e)
in (let _109_526 = (desugar_typ env t)
in (_109_527, _109_526, None)))
in (FStar_Absyn_Syntax.mk_Exp_ascribed _109_528))
in (FStar_All.pipe_left pos _109_529))
end
| FStar_Parser_AST.Record (_43_1428, []) -> begin
(Prims.raise (FStar_Absyn_Syntax.Error (("Unexpected empty record", top.FStar_Parser_AST.range))))
end
| FStar_Parser_AST.Record (eopt, fields) -> begin
(let _43_1439 = (FStar_List.hd fields)
in (match (_43_1439) with
| (f, _43_1438) -> begin
(let qfn = (fun g -> (FStar_Absyn_Syntax.lid_of_ids (FStar_List.append f.FStar_Absyn_Syntax.ns ((g)::[]))))
in (let _43_1445 = (FStar_Parser_DesugarEnv.fail_or env (FStar_Parser_DesugarEnv.try_lookup_record_by_field_name env) f)
in (match (_43_1445) with
| (record, _43_1444) -> begin
(let get_field = (fun xopt f -> (let fn = f.FStar_Absyn_Syntax.ident
in (let found = (FStar_All.pipe_right fields (FStar_Util.find_opt (fun _43_1453 -> (match (_43_1453) with
| (g, _43_1452) -> begin
(let gn = g.FStar_Absyn_Syntax.ident
in (fn.FStar_Absyn_Syntax.idText = gn.FStar_Absyn_Syntax.idText))
end))))
in (match (found) with
| Some (_43_1457, e) -> begin
(let _109_537 = (qfn fn)
in (_109_537, e))
end
| None -> begin
(match (xopt) with
| None -> begin
(let _109_541 = (let _109_540 = (let _109_539 = (let _109_538 = (FStar_Absyn_Syntax.text_of_lid f)
in (FStar_Util.format1 "Field %s is missing" _109_538))
in (_109_539, top.FStar_Parser_AST.range))
in FStar_Absyn_Syntax.Error (_109_540))
in (Prims.raise _109_541))
end
| Some (x) -> begin
(let _109_542 = (qfn fn)
in (_109_542, (FStar_Parser_AST.mk_term (FStar_Parser_AST.Project ((x, f))) x.FStar_Parser_AST.range x.FStar_Parser_AST.level)))
end)
end))))
in (let recterm = (match (eopt) with
| None -> begin
(let _109_547 = (let _109_546 = (FStar_All.pipe_right record.FStar_Parser_DesugarEnv.fields (FStar_List.map (fun _43_1469 -> (match (_43_1469) with
| (f, _43_1468) -> begin
(let _109_545 = (let _109_544 = (get_field None f)
in (FStar_All.pipe_left Prims.snd _109_544))
in (_109_545, FStar_Parser_AST.Nothing))
end))))
in (record.FStar_Parser_DesugarEnv.constrname, _109_546))
in FStar_Parser_AST.Construct (_109_547))
end
| Some (e) -> begin
(let x = (FStar_Absyn_Util.genident (Some (e.FStar_Parser_AST.range)))
in (let xterm = (let _109_549 = (let _109_548 = (FStar_Absyn_Syntax.lid_of_ids ((x)::[]))
in FStar_Parser_AST.Var (_109_548))
in (FStar_Parser_AST.mk_term _109_549 x.FStar_Absyn_Syntax.idRange FStar_Parser_AST.Expr))
in (let record = (let _109_552 = (let _109_551 = (FStar_All.pipe_right record.FStar_Parser_DesugarEnv.fields (FStar_List.map (fun _43_1477 -> (match (_43_1477) with
| (f, _43_1476) -> begin
(get_field (Some (xterm)) f)
end))))
in (None, _109_551))
in FStar_Parser_AST.Record (_109_552))
in FStar_Parser_AST.Let ((false, (((FStar_Parser_AST.mk_pattern (FStar_Parser_AST.PatVar ((x, false))) x.FStar_Absyn_Syntax.idRange), e))::[], (FStar_Parser_AST.mk_term record top.FStar_Parser_AST.range top.FStar_Parser_AST.level))))))
end)
in (let recterm = (FStar_Parser_AST.mk_term recterm top.FStar_Parser_AST.range top.FStar_Parser_AST.level)
in (let e = (desugar_exp env recterm)
in (match (e.FStar_Absyn_Syntax.n) with
| FStar_Absyn_Syntax.Exp_meta (FStar_Absyn_Syntax.Meta_desugared ({FStar_Absyn_Syntax.n = FStar_Absyn_Syntax.Exp_app ({FStar_Absyn_Syntax.n = FStar_Absyn_Syntax.Exp_fvar (fv, _43_1500); FStar_Absyn_Syntax.tk = _43_1497; FStar_Absyn_Syntax.pos = _43_1495; FStar_Absyn_Syntax.fvs = _43_1493; FStar_Absyn_Syntax.uvs = _43_1491}, args); FStar_Absyn_Syntax.tk = _43_1489; FStar_Absyn_Syntax.pos = _43_1487; FStar_Absyn_Syntax.fvs = _43_1485; FStar_Absyn_Syntax.uvs = _43_1483}, FStar_Absyn_Syntax.Data_app)) -> begin
(let e = (let _109_562 = (let _109_561 = (let _109_560 = (let _109_559 = (let _109_558 = (let _109_557 = (let _109_556 = (let _109_555 = (FStar_All.pipe_right record.FStar_Parser_DesugarEnv.fields (FStar_List.map Prims.fst))
in (record.FStar_Parser_DesugarEnv.typename, _109_555))
in FStar_Absyn_Syntax.Record_ctor (_109_556))
in Some (_109_557))
in (fv, _109_558))
in (FStar_Absyn_Syntax.mk_Exp_fvar _109_559 None e.FStar_Absyn_Syntax.pos))
in (_109_560, args))
in (FStar_Absyn_Syntax.mk_Exp_app _109_561))
in (FStar_All.pipe_left pos _109_562))
in (FStar_Absyn_Syntax.mk_Exp_meta (FStar_Absyn_Syntax.Meta_desugared ((e, FStar_Absyn_Syntax.Data_app)))))
end
| _43_1514 -> begin
e
end)))))
end)))
end))
end
| FStar_Parser_AST.Project (e, f) -> begin
(let _43_1522 = (FStar_Parser_DesugarEnv.fail_or env (FStar_Parser_DesugarEnv.try_lookup_record_by_field_name env) f)
in (match (_43_1522) with
| (_43_1520, fieldname) -> begin
(let e = (desugar_exp env e)
in (let fn = (let _43_1527 = (FStar_Util.prefix fieldname.FStar_Absyn_Syntax.ns)
in (match (_43_1527) with
| (ns, _43_1526) -> begin
(FStar_Absyn_Syntax.lid_of_ids (FStar_List.append ns ((f.FStar_Absyn_Syntax.ident)::[])))
end))
in (let _109_570 = (let _109_569 = (let _109_568 = (let _109_565 = (FStar_Absyn_Syntax.range_of_lid f)
in (FStar_Absyn_Util.fvar (Some (FStar_Absyn_Syntax.Record_projector (fn))) fieldname _109_565))
in (let _109_567 = (let _109_566 = (FStar_Absyn_Syntax.varg e)
in (_109_566)::[])
in (_109_568, _109_567)))
in (FStar_Absyn_Syntax.mk_Exp_app _109_569))
in (FStar_All.pipe_left pos _109_570))))
end))
end
| FStar_Parser_AST.Paren (e) -> begin
(desugar_exp env e)
end
| _43_1532 -> begin
(FStar_Parser_AST.error "Unexpected term" top top.FStar_Parser_AST.range)
end))))
and desugar_typ = (fun env top -> (let wpos = (fun t -> (t None top.FStar_Parser_AST.range))
in (let setpos = (fun t -> (let _43_1539 = t
in {FStar_Absyn_Syntax.n = _43_1539.FStar_Absyn_Syntax.n; FStar_Absyn_Syntax.tk = _43_1539.FStar_Absyn_Syntax.tk; FStar_Absyn_Syntax.pos = top.FStar_Parser_AST.range; FStar_Absyn_Syntax.fvs = _43_1539.FStar_Absyn_Syntax.fvs; FStar_Absyn_Syntax.uvs = _43_1539.FStar_Absyn_Syntax.uvs}))
in (let top = (unparen top)
in (let head_and_args = (fun t -> (let rec aux = (fun args t -> (match ((let _109_593 = (unparen t)
in _109_593.FStar_Parser_AST.tm)) with
| FStar_Parser_AST.App (t, arg, imp) -> begin
(aux (((arg, imp))::args) t)
end
| FStar_Parser_AST.Construct (l, args') -> begin
({FStar_Parser_AST.tm = FStar_Parser_AST.Name (l); FStar_Parser_AST.range = t.FStar_Parser_AST.range; FStar_Parser_AST.level = t.FStar_Parser_AST.level}, (FStar_List.append args' args))
end
| _43_1557 -> begin
(t, args)
end))
in (aux [] t)))
in (match (top.FStar_Parser_AST.tm) with
| FStar_Parser_AST.Wild -> begin
(setpos FStar_Absyn_Syntax.tun)
end
| FStar_Parser_AST.Requires (t, lopt) -> begin
(let t = (label_conjuncts "pre-condition" true lopt t)
in (match ((is_type env t)) with
| true -> begin
(desugar_typ env t)
end
| false -> begin
(let _109_594 = (desugar_exp env t)
in (FStar_All.pipe_right _109_594 FStar_Absyn_Util.b2t))
end))
end
| FStar_Parser_AST.Ensures (t, lopt) -> begin
(let t = (label_conjuncts "post-condition" false lopt t)
in (match ((is_type env t)) with
| true -> begin
(desugar_typ env t)
end
| false -> begin
(let _109_595 = (desugar_exp env t)
in (FStar_All.pipe_right _109_595 FStar_Absyn_Util.b2t))
end))
end
| FStar_Parser_AST.Op ("*", t1::_43_1571::[]) -> begin
(match ((is_type env t1)) with
| true -> begin
(let rec flatten = (fun t -> (match (t.FStar_Parser_AST.tm) with
| FStar_Parser_AST.Op ("*", t1::t2::[]) -> begin
(let rest = (flatten t2)
in (t1)::rest)
end
| _43_1586 -> begin
(t)::[]
end))
in (let targs = (let _109_600 = (flatten top)
in (FStar_All.pipe_right _109_600 (FStar_List.map (fun t -> (let _109_599 = (desugar_typ env t)
in (FStar_Absyn_Syntax.targ _109_599))))))
in (let tup = (let _109_601 = (FStar_Absyn_Util.mk_tuple_lid (FStar_List.length targs) top.FStar_Parser_AST.range)
in (FStar_Parser_DesugarEnv.fail_or env (FStar_Parser_DesugarEnv.try_lookup_typ_name env) _109_601))
in (FStar_All.pipe_left wpos (FStar_Absyn_Syntax.mk_Typ_app (tup, targs))))))
end
| false -> begin
(let _109_607 = (let _109_606 = (let _109_605 = (let _109_604 = (FStar_Parser_AST.term_to_string t1)
in (FStar_Util.format1 "The operator \"*\" is resolved here as multiplication since \"%s\" is a term, although a type was expected" _109_604))
in (_109_605, top.FStar_Parser_AST.range))
in FStar_Absyn_Syntax.Error (_109_606))
in (Prims.raise _109_607))
end)
end
| FStar_Parser_AST.Op ("=!=", args) -> begin
(desugar_typ env (FStar_Parser_AST.mk_term (FStar_Parser_AST.Op (("~", ((FStar_Parser_AST.mk_term (FStar_Parser_AST.Op (("==", args))) top.FStar_Parser_AST.range top.FStar_Parser_AST.level))::[]))) top.FStar_Parser_AST.range top.FStar_Parser_AST.level))
end
| FStar_Parser_AST.Op (s, args) -> begin
(match ((op_as_tylid env (FStar_List.length args) top.FStar_Parser_AST.range s)) with
| None -> begin
(let _109_608 = (desugar_exp env top)
in (FStar_All.pipe_right _109_608 FStar_Absyn_Util.b2t))
end
| Some (l) -> begin
(let args = (FStar_List.map (fun t -> (let _109_610 = (desugar_typ_or_exp env t)
in (FStar_All.pipe_left (arg_withimp_t FStar_Parser_AST.Nothing) _109_610))) args)
in (let _109_611 = (FStar_Absyn_Util.ftv l FStar_Absyn_Syntax.kun)
in (FStar_Absyn_Util.mk_typ_app _109_611 args)))
end)
end
| FStar_Parser_AST.Tvar (a) -> begin
(let _109_612 = (FStar_Parser_DesugarEnv.fail_or2 (FStar_Parser_DesugarEnv.try_lookup_typ_var env) a)
in (FStar_All.pipe_left setpos _109_612))
end
| (FStar_Parser_AST.Var (l)) | (FStar_Parser_AST.Name (l)) when ((FStar_List.length l.FStar_Absyn_Syntax.ns) = 0) -> begin
(match ((FStar_Parser_DesugarEnv.try_lookup_typ_var env l.FStar_Absyn_Syntax.ident)) with
| Some (t) -> begin
(setpos t)
end
| None -> begin
(let _109_613 = (FStar_Parser_DesugarEnv.fail_or env (FStar_Parser_DesugarEnv.try_lookup_typ_name env) l)
in (FStar_All.pipe_left setpos _109_613))
end)
end
| (FStar_Parser_AST.Var (l)) | (FStar_Parser_AST.Name (l)) -> begin
(let l = (FStar_Absyn_Util.set_lid_range l top.FStar_Parser_AST.range)
in (let _109_614 = (FStar_Parser_DesugarEnv.fail_or env (FStar_Parser_DesugarEnv.try_lookup_typ_name env) l)
in (FStar_All.pipe_left setpos _109_614)))
end
| FStar_Parser_AST.Construct (l, args) -> begin
(let t = (let _109_615 = (FStar_Parser_DesugarEnv.fail_or env (FStar_Parser_DesugarEnv.try_lookup_typ_name env) l)
in (FStar_All.pipe_left setpos _109_615))
in (let args = (FStar_List.map (fun _43_1622 -> (match (_43_1622) with
| (t, imp) -> begin
(let _109_617 = (desugar_typ_or_exp env t)
in (FStar_All.pipe_left (arg_withimp_t imp) _109_617))
end)) args)
in (FStar_Absyn_Util.mk_typ_app t args)))
end
| FStar_Parser_AST.Abs (binders, body) -> begin
(let rec aux = (fun env bs _43_8 -> (match (_43_8) with
| [] -> begin
(let body = (desugar_typ env body)
in (FStar_All.pipe_left wpos (FStar_Absyn_Syntax.mk_Typ_lam ((FStar_List.rev bs), body))))
end
| hd::tl -> begin
(let _43_1640 = (desugar_binding_pat env hd)
in (match (_43_1640) with
| (env, bnd, pat) -> begin
(match (pat) with
| Some (q) -> begin
(let _109_629 = (let _109_628 = (let _109_627 = (let _109_626 = (FStar_Absyn_Print.pat_to_string q)
in (FStar_Util.format1 "Pattern matching at the type level is not supported; got %s\n" _109_626))
in (_109_627, hd.FStar_Parser_AST.prange))
in FStar_Absyn_Syntax.Error (_109_628))
in (Prims.raise _109_629))
end
| None -> begin
(let b = (binder_of_bnd bnd)
in (aux env ((b)::bs) tl))
end)
end))
end))
in (aux env [] binders))
end
| FStar_Parser_AST.App (_43_1646) -> begin
(let rec aux = (fun args e -> (match ((let _109_634 = (unparen e)
in _109_634.FStar_Parser_AST.tm)) with
| FStar_Parser_AST.App (e, arg, imp) -> begin
(let arg = (let _109_635 = (desugar_typ_or_exp env arg)
in (FStar_All.pipe_left (arg_withimp_t imp) _109_635))
in (aux ((arg)::args) e))
end
| _43_1658 -> begin
(let head = (desugar_typ env e)
in (FStar_All.pipe_left wpos (FStar_Absyn_Syntax.mk_Typ_app (head, args))))
end))
in (aux [] top))
end
| FStar_Parser_AST.Product ([], t) -> begin
(FStar_All.failwith "Impossible: product with no binders")
end
| FStar_Parser_AST.Product (binders, t) -> begin
(let _43_1670 = (uncurry binders t)
in (match (_43_1670) with
| (bs, t) -> begin
(let rec aux = (fun env bs _43_9 -> (match (_43_9) with
| [] -> begin
(let cod = (desugar_comp top.FStar_Parser_AST.range true env t)
in (FStar_All.pipe_left wpos (FStar_Absyn_Syntax.mk_Typ_fun ((FStar_List.rev bs), cod))))
end
| hd::tl -> begin
(let mlenv = (FStar_Parser_DesugarEnv.default_ml env)
in (let bb = (desugar_binder mlenv hd)
in (let _43_1684 = (as_binder env hd.FStar_Parser_AST.aqual bb)
in (match (_43_1684) with
| (b, env) -> begin
(aux env ((b)::bs) tl)
end))))
end))
in (aux env [] bs))
end))
end
| FStar_Parser_AST.Refine (b, f) -> begin
(match ((desugar_exp_binder env b)) with
| (None, _43_1691) -> begin
(FStar_All.failwith "Missing binder in refinement")
end
| b -> begin
(let _43_1705 = (match ((as_binder env None (FStar_Util.Inr (b)))) with
| ((FStar_Util.Inr (x), _43_1697), env) -> begin
(x, env)
end
| _43_1702 -> begin
(FStar_All.failwith "impossible")
end)
in (match (_43_1705) with
| (b, env) -> begin
(let f = (match ((is_type env f)) with
| true -> begin
(desugar_formula env f)
end
| false -> begin
(let _109_646 = (desugar_exp env f)
in (FStar_All.pipe_right _109_646 FStar_Absyn_Util.b2t))
end)
in (FStar_All.pipe_left wpos (FStar_Absyn_Syntax.mk_Typ_refine (b, f))))
end))
end)
end
| (FStar_Parser_AST.NamedTyp (_, t)) | (FStar_Parser_AST.Paren (t)) -> begin
(desugar_typ env t)
end
| FStar_Parser_AST.Ascribed (t, k) -> begin
(let _109_654 = (let _109_653 = (let _109_652 = (desugar_typ env t)
in (let _109_651 = (desugar_kind env k)
in (_109_652, _109_651)))
in (FStar_Absyn_Syntax.mk_Typ_ascribed' _109_653))
in (FStar_All.pipe_left wpos _109_654))
end
| FStar_Parser_AST.Sum (binders, t) -> begin
(let _43_1739 = (FStar_List.fold_left (fun _43_1724 b -> (match (_43_1724) with
| (env, tparams, typs) -> begin
(let _43_1728 = (desugar_exp_binder env b)
in (match (_43_1728) with
| (xopt, t) -> begin
(let _43_1734 = (match (xopt) with
| None -> begin
(let _109_657 = (FStar_Absyn_Util.new_bvd (Some (top.FStar_Parser_AST.range)))
in (env, _109_657))
end
| Some (x) -> begin
(FStar_Parser_DesugarEnv.push_local_vbinding env x)
end)
in (match (_43_1734) with
| (env, x) -> begin
(let _109_661 = (let _109_660 = (let _109_659 = (let _109_658 = (FStar_Absyn_Util.close_with_lam tparams t)
in (FStar_All.pipe_left FStar_Absyn_Syntax.targ _109_658))
in (_109_659)::[])
in (FStar_List.append typs _109_660))
in (env, (FStar_List.append tparams (((FStar_Util.Inr ((FStar_Absyn_Util.bvd_to_bvar_s x t)), None))::[])), _109_661))
end))
end))
end)) (env, [], []) (FStar_List.append binders (((FStar_Parser_AST.mk_binder (FStar_Parser_AST.NoName (t)) t.FStar_Parser_AST.range FStar_Parser_AST.Type None))::[])))
in (match (_43_1739) with
| (env, _43_1737, targs) -> begin
(let tup = (let _109_662 = (FStar_Absyn_Util.mk_dtuple_lid (FStar_List.length targs) top.FStar_Parser_AST.range)
in (FStar_Parser_DesugarEnv.fail_or env (FStar_Parser_DesugarEnv.try_lookup_typ_name env) _109_662))
in (FStar_All.pipe_left wpos (FStar_Absyn_Syntax.mk_Typ_app (tup, targs))))
end))
end
| FStar_Parser_AST.Record (_43_1742) -> begin
(FStar_All.failwith "Unexpected record type")
end
| (FStar_Parser_AST.If (_)) | (FStar_Parser_AST.Labeled (_)) -> begin
(desugar_formula env top)
end
| _43_1751 when (top.FStar_Parser_AST.level = FStar_Parser_AST.Formula) -> begin
(desugar_formula env top)
end
| _43_1753 -> begin
(FStar_Parser_AST.error "Expected a type" top top.FStar_Parser_AST.range)
end))))))
and desugar_comp = (fun r default_ok env t -> (let fail = (fun msg -> (Prims.raise (FStar_Absyn_Syntax.Error ((msg, r)))))
in (let pre_process_comp_typ = (fun t -> (let _43_1764 = (head_and_args t)
in (match (_43_1764) with
| (head, args) -> begin
(match (head.FStar_Parser_AST.tm) with
| FStar_Parser_AST.Name (lemma) when (lemma.FStar_Absyn_Syntax.ident.FStar_Absyn_Syntax.idText = "Lemma") -> begin
(let unit = ((FStar_Parser_AST.mk_term (FStar_Parser_AST.Name (FStar_Absyn_Const.unit_lid)) t.FStar_Parser_AST.range FStar_Parser_AST.Type), FStar_Parser_AST.Nothing)
in (let nil_pat = ((FStar_Parser_AST.mk_term (FStar_Parser_AST.Name (FStar_Absyn_Const.nil_lid)) t.FStar_Parser_AST.range FStar_Parser_AST.Expr), FStar_Parser_AST.Nothing)
in (let _43_1790 = (FStar_All.pipe_right args (FStar_List.partition (fun _43_1772 -> (match (_43_1772) with
| (arg, _43_1771) -> begin
(match ((let _109_674 = (unparen arg)
in _109_674.FStar_Parser_AST.tm)) with
| FStar_Parser_AST.App ({FStar_Parser_AST.tm = FStar_Parser_AST.Var (d); FStar_Parser_AST.range = _43_1776; FStar_Parser_AST.level = _43_1774}, _43_1781, _43_1783) -> begin
(d.FStar_Absyn_Syntax.ident.FStar_Absyn_Syntax.idText = "decreases")
end
| _43_1787 -> begin
false
end)
end))))
in (match (_43_1790) with
| (decreases_clause, args) -> begin
(let args = (match (args) with
| [] -> begin
(Prims.raise (FStar_Absyn_Syntax.Error (("Not enough arguments to \'Lemma\'", t.FStar_Parser_AST.range))))
end
| ens::[] -> begin
(let req_true = ((FStar_Parser_AST.mk_term (FStar_Parser_AST.Requires (((FStar_Parser_AST.mk_term (FStar_Parser_AST.Name (FStar_Absyn_Const.true_lid)) t.FStar_Parser_AST.range FStar_Parser_AST.Formula), None))) t.FStar_Parser_AST.range FStar_Parser_AST.Type), FStar_Parser_AST.Nothing)
in (unit)::(req_true)::(ens)::(nil_pat)::[])
end
| req::ens::[] -> begin
(unit)::(req)::(ens)::(nil_pat)::[]
end
| more -> begin
(unit)::more
end)
in (let t = (FStar_Parser_AST.mk_term (FStar_Parser_AST.Construct ((lemma, (FStar_List.append args decreases_clause)))) t.FStar_Parser_AST.range t.FStar_Parser_AST.level)
in (desugar_typ env t)))
end))))
end
| FStar_Parser_AST.Name (tot) when (((tot.FStar_Absyn_Syntax.ident.FStar_Absyn_Syntax.idText = "Tot") && (not ((FStar_Parser_DesugarEnv.is_effect_name env FStar_Absyn_Const.effect_Tot_lid)))) && (let _109_675 = (FStar_Parser_DesugarEnv.current_module env)
in (FStar_Absyn_Syntax.lid_equals _109_675 FStar_Absyn_Const.prims_lid))) -> begin
(let args = (FStar_List.map (fun _43_1805 -> (match (_43_1805) with
| (t, imp) -> begin
(let _109_677 = (desugar_typ_or_exp env t)
in (FStar_All.pipe_left (arg_withimp_t imp) _109_677))
end)) args)
in (let _109_678 = (FStar_Absyn_Util.ftv FStar_Absyn_Const.effect_Tot_lid FStar_Absyn_Syntax.kun)
in (FStar_Absyn_Util.mk_typ_app _109_678 args)))
end
| _43_1808 -> begin
(desugar_typ env t)
end)
end)))
in (let t = (pre_process_comp_typ t)
in (let _43_1812 = (FStar_Absyn_Util.head_and_args t)
in (match (_43_1812) with
| (head, args) -> begin
(match ((let _109_680 = (let _109_679 = (FStar_Absyn_Util.compress_typ head)
in _109_679.FStar_Absyn_Syntax.n)
in (_109_680, args))) with
| (FStar_Absyn_Syntax.Typ_const (eff), (FStar_Util.Inl (result_typ), _43_1819)::rest) -> begin
(let _43_1859 = (FStar_All.pipe_right rest (FStar_List.partition (fun _43_10 -> (match (_43_10) with
| (FStar_Util.Inr (_43_1825), _43_1828) -> begin
false
end
| (FStar_Util.Inl (t), _43_1833) -> begin
(match (t.FStar_Absyn_Syntax.n) with
| FStar_Absyn_Syntax.Typ_app ({FStar_Absyn_Syntax.n = FStar_Absyn_Syntax.Typ_const (fv); FStar_Absyn_Syntax.tk = _43_1842; FStar_Absyn_Syntax.pos = _43_1840; FStar_Absyn_Syntax.fvs = _43_1838; FStar_Absyn_Syntax.uvs = _43_1836}, (FStar_Util.Inr (_43_1847), _43_1850)::[]) -> begin
(FStar_Absyn_Syntax.lid_equals fv.FStar_Absyn_Syntax.v FStar_Absyn_Const.decreases_lid)
end
| _43_1856 -> begin
false
end)
end))))
in (match (_43_1859) with
| (dec, rest) -> begin
(let decreases_clause = (FStar_All.pipe_right dec (FStar_List.map (fun _43_11 -> (match (_43_11) with
| (FStar_Util.Inl (t), _43_1864) -> begin
(match (t.FStar_Absyn_Syntax.n) with
| FStar_Absyn_Syntax.Typ_app (_43_1867, (FStar_Util.Inr (arg), _43_1871)::[]) -> begin
FStar_Absyn_Syntax.DECREASES (arg)
end
| _43_1877 -> begin
(FStar_All.failwith "impos")
end)
end
| _43_1879 -> begin
(FStar_All.failwith "impos")
end))))
in (match (((FStar_Parser_DesugarEnv.is_effect_name env eff.FStar_Absyn_Syntax.v) || (FStar_Absyn_Syntax.lid_equals eff.FStar_Absyn_Syntax.v FStar_Absyn_Const.effect_Tot_lid))) with
| true -> begin
(match (((FStar_Absyn_Syntax.lid_equals eff.FStar_Absyn_Syntax.v FStar_Absyn_Const.effect_Tot_lid) && ((FStar_List.length decreases_clause) = 0))) with
| true -> begin
(FStar_Absyn_Syntax.mk_Total result_typ)
end
| false -> begin
(let flags = (match ((FStar_Absyn_Syntax.lid_equals eff.FStar_Absyn_Syntax.v FStar_Absyn_Const.effect_Lemma_lid)) with
| true -> begin
(FStar_Absyn_Syntax.LEMMA)::[]
end
| false -> begin
(match ((FStar_Absyn_Syntax.lid_equals eff.FStar_Absyn_Syntax.v FStar_Absyn_Const.effect_Tot_lid)) with
| true -> begin
(FStar_Absyn_Syntax.TOTAL)::[]
end
| false -> begin
(match ((FStar_Absyn_Syntax.lid_equals eff.FStar_Absyn_Syntax.v FStar_Absyn_Const.effect_ML_lid)) with
| true -> begin
(FStar_Absyn_Syntax.MLEFFECT)::[]
end
| false -> begin
[]
end)
end)
end)
in (FStar_Absyn_Syntax.mk_Comp {FStar_Absyn_Syntax.effect_name = eff.FStar_Absyn_Syntax.v; FStar_Absyn_Syntax.result_typ = result_typ; FStar_Absyn_Syntax.effect_args = rest; FStar_Absyn_Syntax.flags = (FStar_List.append flags decreases_clause)}))
end)
end
| false -> begin
(match (default_ok) with
| true -> begin
(env.FStar_Parser_DesugarEnv.default_result_effect t r)
end
| false -> begin
(let _109_684 = (let _109_683 = (FStar_Absyn_Print.typ_to_string t)
in (FStar_Util.format1 "%s is not an effect" _109_683))
in (fail _109_684))
end)
end))
end))
end
| _43_1883 -> begin
(match (default_ok) with
| true -> begin
(env.FStar_Parser_DesugarEnv.default_result_effect t r)
end
| false -> begin
(let _109_686 = (let _109_685 = (FStar_Absyn_Print.typ_to_string t)
in (FStar_Util.format1 "%s is not an effect" _109_685))
in (fail _109_686))
end)
end)
end))))))
and desugar_kind = (fun env k -> (let pos = (fun f -> (f k.FStar_Parser_AST.range))
in (let setpos = (fun kk -> (let _43_1890 = kk
in {FStar_Absyn_Syntax.n = _43_1890.FStar_Absyn_Syntax.n; FStar_Absyn_Syntax.tk = _43_1890.FStar_Absyn_Syntax.tk; FStar_Absyn_Syntax.pos = k.FStar_Parser_AST.range; FStar_Absyn_Syntax.fvs = _43_1890.FStar_Absyn_Syntax.fvs; FStar_Absyn_Syntax.uvs = _43_1890.FStar_Absyn_Syntax.uvs}))
in (let k = (unparen k)
in (match (k.FStar_Parser_AST.tm) with
| FStar_Parser_AST.Name ({FStar_Absyn_Syntax.ns = _43_1899; FStar_Absyn_Syntax.ident = _43_1897; FStar_Absyn_Syntax.nsstr = _43_1895; FStar_Absyn_Syntax.str = "Type"}) -> begin
(setpos FStar_Absyn_Syntax.mk_Kind_type)
end
| FStar_Parser_AST.Name ({FStar_Absyn_Syntax.ns = _43_1908; FStar_Absyn_Syntax.ident = _43_1906; FStar_Absyn_Syntax.nsstr = _43_1904; FStar_Absyn_Syntax.str = "Effect"}) -> begin
(setpos FStar_Absyn_Syntax.mk_Kind_effect)
end
| FStar_Parser_AST.Name (l) -> begin
(match ((let _109_698 = (FStar_Parser_DesugarEnv.qualify_lid env l)
in (FStar_Parser_DesugarEnv.find_kind_abbrev env _109_698))) with
| Some (l) -> begin
(FStar_All.pipe_left pos (FStar_Absyn_Syntax.mk_Kind_abbrev ((l, []), FStar_Absyn_Syntax.mk_Kind_unknown)))
end
| _43_1916 -> begin
(FStar_Parser_AST.error "Unexpected term where kind was expected" k k.FStar_Parser_AST.range)
end)
end
| FStar_Parser_AST.Wild -> begin
(setpos FStar_Absyn_Syntax.kun)
end
| FStar_Parser_AST.Product (bs, k) -> begin
(let _43_1924 = (uncurry bs k)
in (match (_43_1924) with
| (bs, k) -> begin
(let rec aux = (fun env bs _43_12 -> (match (_43_12) with
| [] -> begin
(let _109_709 = (let _109_708 = (let _109_707 = (desugar_kind env k)
in ((FStar_List.rev bs), _109_707))
in (FStar_Absyn_Syntax.mk_Kind_arrow _109_708))
in (FStar_All.pipe_left pos _109_709))
end
| hd::tl -> begin
(let _43_1935 = (let _109_711 = (let _109_710 = (FStar_Parser_DesugarEnv.default_ml env)
in (desugar_binder _109_710 hd))
in (FStar_All.pipe_right _109_711 (as_binder env hd.FStar_Parser_AST.aqual)))
in (match (_43_1935) with
| (b, env) -> begin
(aux env ((b)::bs) tl)
end))
end))
in (aux env [] bs))
end))
end
| FStar_Parser_AST.Construct (l, args) -> begin
(match ((FStar_Parser_DesugarEnv.find_kind_abbrev env l)) with
| None -> begin
(FStar_Parser_AST.error "Unexpected term where kind was expected" k k.FStar_Parser_AST.range)
end
| Some (l) -> begin
(let args = (FStar_List.map (fun _43_1945 -> (match (_43_1945) with
| (t, b) -> begin
(let qual = (match ((b = FStar_Parser_AST.Hash)) with
| true -> begin
Some (FStar_Absyn_Syntax.Implicit)
end
| false -> begin
None
end)
in (let _109_713 = (desugar_typ_or_exp env t)
in (_109_713, qual)))
end)) args)
in (FStar_All.pipe_left pos (FStar_Absyn_Syntax.mk_Kind_abbrev ((l, args), FStar_Absyn_Syntax.mk_Kind_unknown))))
end)
end
| _43_1949 -> begin
(FStar_Parser_AST.error "Unexpected term where kind was expected" k k.FStar_Parser_AST.range)
end)))))
and desugar_formula' = (fun env f -> (let connective = (fun s -> (match (s) with
| "/\\" -> begin
Some (FStar_Absyn_Const.and_lid)
end
| "\\/" -> begin
Some (FStar_Absyn_Const.or_lid)
end
| "==>" -> begin
Some (FStar_Absyn_Const.imp_lid)
end
| "<==>" -> begin
Some (FStar_Absyn_Const.iff_lid)
end
| "~" -> begin
Some (FStar_Absyn_Const.not_lid)
end
| _43_1960 -> begin
None
end))
in (let pos = (fun t -> (t None f.FStar_Parser_AST.range))
in (let setpos = (fun t -> (let _43_1965 = t
in {FStar_Absyn_Syntax.n = _43_1965.FStar_Absyn_Syntax.n; FStar_Absyn_Syntax.tk = _43_1965.FStar_Absyn_Syntax.tk; FStar_Absyn_Syntax.pos = f.FStar_Parser_AST.range; FStar_Absyn_Syntax.fvs = _43_1965.FStar_Absyn_Syntax.fvs; FStar_Absyn_Syntax.uvs = _43_1965.FStar_Absyn_Syntax.uvs}))
in (let desugar_quant = (fun q qt b pats body -> (let tk = (desugar_binder env (let _43_1973 = b
in {FStar_Parser_AST.b = _43_1973.FStar_Parser_AST.b; FStar_Parser_AST.brange = _43_1973.FStar_Parser_AST.brange; FStar_Parser_AST.blevel = FStar_Parser_AST.Formula; FStar_Parser_AST.aqual = _43_1973.FStar_Parser_AST.aqual}))
in (match (tk) with
| FStar_Util.Inl (Some (a), k) -> begin
(let _43_1983 = (FStar_Parser_DesugarEnv.push_local_tbinding env a)
in (match (_43_1983) with
| (env, a) -> begin
(let pats = (FStar_List.map (fun e -> (let _109_744 = (desugar_typ_or_exp env e)
in (FStar_All.pipe_left (arg_withimp_t FStar_Parser_AST.Nothing) _109_744))) pats)
in (let body = (desugar_formula env body)
in (let body = (match (pats) with
| [] -> begin
body
end
| _43_1989 -> begin
(let _109_745 = (FStar_Absyn_Syntax.mk_Typ_meta (FStar_Absyn_Syntax.Meta_pattern ((body, pats))))
in (FStar_All.pipe_left setpos _109_745))
end)
in (let body = (let _109_751 = (let _109_750 = (let _109_749 = (let _109_748 = (FStar_Absyn_Syntax.t_binder (FStar_Absyn_Util.bvd_to_bvar_s a k))
in (_109_748)::[])
in (_109_749, body))
in (FStar_Absyn_Syntax.mk_Typ_lam _109_750))
in (FStar_All.pipe_left pos _109_751))
in (let _109_756 = (let _109_755 = (let _109_752 = (FStar_Absyn_Util.set_lid_range qt b.FStar_Parser_AST.brange)
in (FStar_Absyn_Util.ftv _109_752 FStar_Absyn_Syntax.kun))
in (let _109_754 = (let _109_753 = (FStar_Absyn_Syntax.targ body)
in (_109_753)::[])
in (FStar_Absyn_Util.mk_typ_app _109_755 _109_754)))
in (FStar_All.pipe_left setpos _109_756))))))
end))
end
| FStar_Util.Inr (Some (x), t) -> begin
(let _43_1999 = (FStar_Parser_DesugarEnv.push_local_vbinding env x)
in (match (_43_1999) with
| (env, x) -> begin
(let pats = (FStar_List.map (fun e -> (let _109_758 = (desugar_typ_or_exp env e)
in (FStar_All.pipe_left (arg_withimp_t FStar_Parser_AST.Nothing) _109_758))) pats)
in (let body = (desugar_formula env body)
in (let body = (match (pats) with
| [] -> begin
body
end
| _43_2005 -> begin
(FStar_Absyn_Syntax.mk_Typ_meta (FStar_Absyn_Syntax.Meta_pattern ((body, pats))))
end)
in (let body = (let _109_764 = (let _109_763 = (let _109_762 = (let _109_761 = (FStar_Absyn_Syntax.v_binder (FStar_Absyn_Util.bvd_to_bvar_s x t))
in (_109_761)::[])
in (_109_762, body))
in (FStar_Absyn_Syntax.mk_Typ_lam _109_763))
in (FStar_All.pipe_left pos _109_764))
in (let _109_769 = (let _109_768 = (let _109_765 = (FStar_Absyn_Util.set_lid_range q b.FStar_Parser_AST.brange)
in (FStar_Absyn_Util.ftv _109_765 FStar_Absyn_Syntax.kun))
in (let _109_767 = (let _109_766 = (FStar_Absyn_Syntax.targ body)
in (_109_766)::[])
in (FStar_Absyn_Util.mk_typ_app _109_768 _109_767)))
in (FStar_All.pipe_left setpos _109_769))))))
end))
end
| _43_2009 -> begin
(FStar_All.failwith "impossible")
end)))
in (let push_quant = (fun q binders pats body -> (match (binders) with
| b::b'::_rest -> begin
(let rest = (b')::_rest
in (let body = (let _109_784 = (q (rest, pats, body))
in (let _109_783 = (FStar_Range.union_ranges b'.FStar_Parser_AST.brange body.FStar_Parser_AST.range)
in (FStar_Parser_AST.mk_term _109_784 _109_783 FStar_Parser_AST.Formula)))
in (let _109_785 = (q ((b)::[], [], body))
in (FStar_Parser_AST.mk_term _109_785 f.FStar_Parser_AST.range FStar_Parser_AST.Formula))))
end
| _43_2023 -> begin
(FStar_All.failwith "impossible")
end))
in (match ((let _109_786 = (unparen f)
in _109_786.FStar_Parser_AST.tm)) with
| FStar_Parser_AST.Labeled (f, l, p) -> begin
(let f = (desugar_formula env f)
in (FStar_Absyn_Syntax.mk_Typ_meta (FStar_Absyn_Syntax.Meta_labeled ((f, l, FStar_Absyn_Syntax.dummyRange, p)))))
end
| FStar_Parser_AST.Op ("==", hd::_args) -> begin
(let args = (hd)::_args
in (let args = (FStar_List.map (fun t -> (let _109_788 = (desugar_typ_or_exp env t)
in (FStar_All.pipe_left (arg_withimp_t FStar_Parser_AST.Nothing) _109_788))) args)
in (let eq = (match ((is_type env hd)) with
| true -> begin
(let _109_789 = (FStar_Absyn_Util.set_lid_range FStar_Absyn_Const.eqT_lid f.FStar_Parser_AST.range)
in (FStar_Absyn_Util.ftv _109_789 FStar_Absyn_Syntax.kun))
end
| false -> begin
(let _109_790 = (FStar_Absyn_Util.set_lid_range FStar_Absyn_Const.eq2_lid f.FStar_Parser_AST.range)
in (FStar_Absyn_Util.ftv _109_790 FStar_Absyn_Syntax.kun))
end)
in (FStar_Absyn_Util.mk_typ_app eq args))))
end
| FStar_Parser_AST.Op (s, args) -> begin
(match (((connective s), args)) with
| (Some (conn), _43_2049::_43_2047::[]) -> begin
(let _109_795 = (let _109_791 = (FStar_Absyn_Util.set_lid_range conn f.FStar_Parser_AST.range)
in (FStar_Absyn_Util.ftv _109_791 FStar_Absyn_Syntax.kun))
in (let _109_794 = (FStar_List.map (fun x -> (let _109_793 = (desugar_formula env x)
in (FStar_All.pipe_left FStar_Absyn_Syntax.targ _109_793))) args)
in (FStar_Absyn_Util.mk_typ_app _109_795 _109_794)))
end
| _43_2054 -> begin
(match ((is_type env f)) with
| true -> begin
(desugar_typ env f)
end
| false -> begin
(let _109_796 = (desugar_exp env f)
in (FStar_All.pipe_right _109_796 FStar_Absyn_Util.b2t))
end)
end)
end
| FStar_Parser_AST.If (f1, f2, f3) -> begin
(let _109_801 = (let _109_797 = (FStar_Absyn_Util.set_lid_range FStar_Absyn_Const.ite_lid f.FStar_Parser_AST.range)
in (FStar_Absyn_Util.ftv _109_797 FStar_Absyn_Syntax.kun))
in (let _109_800 = (FStar_List.map (fun x -> (match ((desugar_typ_or_exp env x)) with
| FStar_Util.Inl (t) -> begin
(FStar_Absyn_Syntax.targ t)
end
| FStar_Util.Inr (v) -> begin
(let _109_799 = (FStar_Absyn_Util.b2t v)
in (FStar_All.pipe_left FStar_Absyn_Syntax.targ _109_799))
end)) ((f1)::(f2)::(f3)::[]))
in (FStar_Absyn_Util.mk_typ_app _109_801 _109_800)))
end
| FStar_Parser_AST.QForall (_1::_2::_3, pats, body) -> begin
(let binders = (_1)::(_2)::_3
in (let _109_803 = (push_quant (fun x -> FStar_Parser_AST.QForall (x)) binders pats body)
in (desugar_formula env _109_803)))
end
| FStar_Parser_AST.QExists (_1::_2::_3, pats, body) -> begin
(let binders = (_1)::(_2)::_3
in (let _109_805 = (push_quant (fun x -> FStar_Parser_AST.QExists (x)) binders pats body)
in (desugar_formula env _109_805)))
end
| FStar_Parser_AST.QForall (b::[], pats, body) -> begin
(desugar_quant FStar_Absyn_Const.forall_lid FStar_Absyn_Const.allTyp_lid b pats body)
end
| FStar_Parser_AST.QExists (b::[], pats, body) -> begin
(desugar_quant FStar_Absyn_Const.exists_lid FStar_Absyn_Const.allTyp_lid b pats body)
end
| FStar_Parser_AST.Paren (f) -> begin
(desugar_formula env f)
end
| _43_2102 -> begin
(match ((is_type env f)) with
| true -> begin
(desugar_typ env f)
end
| false -> begin
(let _109_806 = (desugar_exp env f)
in (FStar_All.pipe_left FStar_Absyn_Util.b2t _109_806))
end)
end)))))))
and desugar_formula = (fun env t -> (desugar_formula' (let _43_2105 = env
in {FStar_Parser_DesugarEnv.curmodule = _43_2105.FStar_Parser_DesugarEnv.curmodule; FStar_Parser_DesugarEnv.modules = _43_2105.FStar_Parser_DesugarEnv.modules; FStar_Parser_DesugarEnv.open_namespaces = _43_2105.FStar_Parser_DesugarEnv.open_namespaces; FStar_Parser_DesugarEnv.sigaccum = _43_2105.FStar_Parser_DesugarEnv.sigaccum; FStar_Parser_DesugarEnv.localbindings = _43_2105.FStar_Parser_DesugarEnv.localbindings; FStar_Parser_DesugarEnv.recbindings = _43_2105.FStar_Parser_DesugarEnv.recbindings; FStar_Parser_DesugarEnv.phase = FStar_Parser_AST.Formula; FStar_Parser_DesugarEnv.sigmap = _43_2105.FStar_Parser_DesugarEnv.sigmap; FStar_Parser_DesugarEnv.default_result_effect = _43_2105.FStar_Parser_DesugarEnv.default_result_effect; FStar_Parser_DesugarEnv.iface = _43_2105.FStar_Parser_DesugarEnv.iface; FStar_Parser_DesugarEnv.admitted_iface = _43_2105.FStar_Parser_DesugarEnv.admitted_iface}) t))
and desugar_binder = (fun env b -> (match ((is_type_binder env b)) with
| true -> begin
(let _109_811 = (desugar_type_binder env b)
in FStar_Util.Inl (_109_811))
end
| false -> begin
(let _109_812 = (desugar_exp_binder env b)
in FStar_Util.Inr (_109_812))
end))
and typars_of_binders = (fun env bs -> (let _43_2138 = (FStar_List.fold_left (fun _43_2113 b -> (match (_43_2113) with
| (env, out) -> begin
(let tk = (desugar_binder env (let _43_2115 = b
in {FStar_Parser_AST.b = _43_2115.FStar_Parser_AST.b; FStar_Parser_AST.brange = _43_2115.FStar_Parser_AST.brange; FStar_Parser_AST.blevel = FStar_Parser_AST.Formula; FStar_Parser_AST.aqual = _43_2115.FStar_Parser_AST.aqual}))
in (match (tk) with
| FStar_Util.Inl (Some (a), k) -> begin
(let _43_2125 = (FStar_Parser_DesugarEnv.push_local_tbinding env a)
in (match (_43_2125) with
| (env, a) -> begin
(env, ((FStar_Util.Inl ((FStar_Absyn_Util.bvd_to_bvar_s a k)), b.FStar_Parser_AST.aqual))::out)
end))
end
| FStar_Util.Inr (Some (x), t) -> begin
(let _43_2133 = (FStar_Parser_DesugarEnv.push_local_vbinding env x)
in (match (_43_2133) with
| (env, x) -> begin
(env, ((FStar_Util.Inr ((FStar_Absyn_Util.bvd_to_bvar_s x t)), b.FStar_Parser_AST.aqual))::out)
end))
end
| _43_2135 -> begin
(Prims.raise (FStar_Absyn_Syntax.Error (("Unexpected binder", b.FStar_Parser_AST.brange))))
end))
end)) (env, []) bs)
in (match (_43_2138) with
| (env, tpars) -> begin
(env, (FStar_List.rev tpars))
end)))
and desugar_exp_binder = (fun env b -> (match (b.FStar_Parser_AST.b) with
| FStar_Parser_AST.Annotated (x, t) -> begin
(let _109_819 = (desugar_typ env t)
in (Some (x), _109_819))
end
| FStar_Parser_AST.TVariable (t) -> begin
(let _109_820 = (FStar_Parser_DesugarEnv.fail_or2 (FStar_Parser_DesugarEnv.try_lookup_typ_var env) t)
in (None, _109_820))
end
| FStar_Parser_AST.NoName (t) -> begin
(let _109_821 = (desugar_typ env t)
in (None, _109_821))
end
| FStar_Parser_AST.Variable (x) -> begin
(Some (x), FStar_Absyn_Syntax.tun)
end
| _43_2152 -> begin
(Prims.raise (FStar_Absyn_Syntax.Error (("Unexpected domain of an arrow or sum (expected a type)", b.FStar_Parser_AST.brange))))
end))
and desugar_type_binder = (fun env b -> (let fail = (fun _43_2156 -> (match (()) with
| () -> begin
(Prims.raise (FStar_Absyn_Syntax.Error (("Unexpected domain of an arrow or sum (expected a kind)", b.FStar_Parser_AST.brange))))
end))
in (match (b.FStar_Parser_AST.b) with
| (FStar_Parser_AST.Annotated (x, t)) | (FStar_Parser_AST.TAnnotated (x, t)) -> begin
(let _109_826 = (desugar_kind env t)
in (Some (x), _109_826))
end
| FStar_Parser_AST.NoName (t) -> begin
(let _109_827 = (desugar_kind env t)
in (None, _109_827))
end
| FStar_Parser_AST.TVariable (x) -> begin
(Some (x), (let _43_2167 = FStar_Absyn_Syntax.mk_Kind_type
in {FStar_Absyn_Syntax.n = _43_2167.FStar_Absyn_Syntax.n; FStar_Absyn_Syntax.tk = _43_2167.FStar_Absyn_Syntax.tk; FStar_Absyn_Syntax.pos = b.FStar_Parser_AST.brange; FStar_Absyn_Syntax.fvs = _43_2167.FStar_Absyn_Syntax.fvs; FStar_Absyn_Syntax.uvs = _43_2167.FStar_Absyn_Syntax.uvs}))
end
| _43_2170 -> begin
(fail ())
end)))

let gather_tc_binders = (fun tps k -> (let rec aux = (fun bs k -> (match (k.FStar_Absyn_Syntax.n) with
| FStar_Absyn_Syntax.Kind_arrow (binders, k) -> begin
(aux (FStar_List.append bs binders) k)
end
| FStar_Absyn_Syntax.Kind_abbrev (_43_2181, k) -> begin
(aux bs k)
end
| _43_2186 -> begin
bs
end))
in (let _109_836 = (aux tps k)
in (FStar_All.pipe_right _109_836 FStar_Absyn_Util.name_binders))))

let mk_data_discriminators = (fun quals env t tps k datas -> (let quals = (fun q -> (match (((FStar_All.pipe_left Prims.op_Negation env.FStar_Parser_DesugarEnv.iface) || env.FStar_Parser_DesugarEnv.admitted_iface)) with
| true -> begin
(FStar_List.append ((FStar_Absyn_Syntax.Assumption)::q) quals)
end
| false -> begin
(FStar_List.append q quals)
end))
in (let binders = (gather_tc_binders tps k)
in (let p = (FStar_Absyn_Syntax.range_of_lid t)
in (let imp_binders = (FStar_All.pipe_right binders (FStar_List.map (fun _43_2200 -> (match (_43_2200) with
| (x, _43_2199) -> begin
(x, Some (FStar_Absyn_Syntax.Implicit))
end))))
in (let binders = (let _109_857 = (let _109_856 = (let _109_855 = (let _109_854 = (let _109_853 = (FStar_Absyn_Util.ftv t FStar_Absyn_Syntax.kun)
in (let _109_852 = (FStar_Absyn_Util.args_of_non_null_binders binders)
in (_109_853, _109_852)))
in (FStar_Absyn_Syntax.mk_Typ_app' _109_854 None p))
in (FStar_All.pipe_left FStar_Absyn_Syntax.null_v_binder _109_855))
in (_109_856)::[])
in (FStar_List.append imp_binders _109_857))
in (let disc_type = (let _109_860 = (let _109_859 = (let _109_858 = (FStar_Absyn_Util.ftv FStar_Absyn_Const.bool_lid FStar_Absyn_Syntax.ktype)
in (FStar_Absyn_Util.total_comp _109_858 p))
in (binders, _109_859))
in (FStar_Absyn_Syntax.mk_Typ_fun _109_860 None p))
in (FStar_All.pipe_right datas (FStar_List.map (fun d -> (let disc_name = (FStar_Absyn_Util.mk_discriminator d)
in (let _109_864 = (let _109_863 = (quals ((FStar_Absyn_Syntax.Logic)::(FStar_Absyn_Syntax.Discriminator (d))::[]))
in (let _109_862 = (FStar_Absyn_Syntax.range_of_lid disc_name)
in (disc_name, disc_type, _109_863, _109_862)))
in FStar_Absyn_Syntax.Sig_val_decl (_109_864)))))))))))))

let mk_indexed_projectors = (fun fvq refine_domain env _43_2212 lid formals t -> (match (_43_2212) with
| (tc, tps, k) -> begin
(let binders = (gather_tc_binders tps k)
in (let p = (FStar_Absyn_Syntax.range_of_lid lid)
in (let pos = (fun q -> (FStar_Absyn_Syntax.withinfo q None p))
in (let projectee = (let _109_875 = (FStar_Absyn_Syntax.mk_ident ("projectee", p))
in (let _109_874 = (FStar_Absyn_Util.genident (Some (p)))
in {FStar_Absyn_Syntax.ppname = _109_875; FStar_Absyn_Syntax.realname = _109_874}))
in (let arg_exp = (FStar_Absyn_Util.bvd_to_exp projectee FStar_Absyn_Syntax.tun)
in (let arg_binder = (let arg_typ = (let _109_878 = (let _109_877 = (FStar_Absyn_Util.ftv tc FStar_Absyn_Syntax.kun)
in (let _109_876 = (FStar_Absyn_Util.args_of_non_null_binders binders)
in (_109_877, _109_876)))
in (FStar_Absyn_Syntax.mk_Typ_app' _109_878 None p))
in (match ((not (refine_domain))) with
| true -> begin
(FStar_Absyn_Syntax.v_binder (FStar_Absyn_Util.bvd_to_bvar_s projectee arg_typ))
end
| false -> begin
(let disc_name = (FStar_Absyn_Util.mk_discriminator lid)
in (let x = (FStar_Absyn_Util.gen_bvar arg_typ)
in (let _109_888 = (let _109_887 = (let _109_886 = (let _109_885 = (let _109_884 = (let _109_883 = (let _109_882 = (FStar_Absyn_Util.fvar None disc_name p)
in (let _109_881 = (let _109_880 = (let _109_879 = (FStar_Absyn_Util.bvar_to_exp x)
in (FStar_All.pipe_left FStar_Absyn_Syntax.varg _109_879))
in (_109_880)::[])
in (_109_882, _109_881)))
in (FStar_Absyn_Syntax.mk_Exp_app _109_883 None p))
in (FStar_Absyn_Util.b2t _109_884))
in (x, _109_885))
in (FStar_Absyn_Syntax.mk_Typ_refine _109_886 None p))
in (FStar_All.pipe_left (FStar_Absyn_Util.bvd_to_bvar_s projectee) _109_887))
in (FStar_All.pipe_left FStar_Absyn_Syntax.v_binder _109_888))))
end))
in (let imp_binders = (FStar_All.pipe_right binders (FStar_List.map (fun _43_2229 -> (match (_43_2229) with
| (x, _43_2228) -> begin
(x, Some (FStar_Absyn_Syntax.Implicit))
end))))
in (let binders = (FStar_List.append imp_binders ((arg_binder)::[]))
in (let arg = (FStar_Absyn_Util.arg_of_non_null_binder arg_binder)
in (let subst = (let _109_898 = (FStar_All.pipe_right formals (FStar_List.mapi (fun i f -> (match ((Prims.fst f)) with
| FStar_Util.Inl (a) -> begin
(match ((FStar_All.pipe_right binders (FStar_Util.for_some (fun _43_13 -> (match (_43_13) with
| (FStar_Util.Inl (b), _43_2241) -> begin
(FStar_Absyn_Util.bvd_eq a.FStar_Absyn_Syntax.v b.FStar_Absyn_Syntax.v)
end
| _43_2244 -> begin
false
end))))) with
| true -> begin
[]
end
| false -> begin
(let _43_2248 = (FStar_Absyn_Util.mk_field_projector_name lid a i)
in (match (_43_2248) with
| (field_name, _43_2247) -> begin
(let proj = (let _109_894 = (let _109_893 = (FStar_Absyn_Util.ftv field_name FStar_Absyn_Syntax.kun)
in (_109_893, (arg)::[]))
in (FStar_Absyn_Syntax.mk_Typ_app _109_894 None p))
in (FStar_Util.Inl ((a.FStar_Absyn_Syntax.v, proj)))::[])
end))
end)
end
| FStar_Util.Inr (x) -> begin
(match ((FStar_All.pipe_right binders (FStar_Util.for_some (fun _43_14 -> (match (_43_14) with
| (FStar_Util.Inr (y), _43_2256) -> begin
(FStar_Absyn_Util.bvd_eq x.FStar_Absyn_Syntax.v y.FStar_Absyn_Syntax.v)
end
| _43_2259 -> begin
false
end))))) with
| true -> begin
[]
end
| false -> begin
(let _43_2263 = (FStar_Absyn_Util.mk_field_projector_name lid x i)
in (match (_43_2263) with
| (field_name, _43_2262) -> begin
(let proj = (let _109_897 = (let _109_896 = (FStar_Absyn_Util.fvar None field_name p)
in (_109_896, (arg)::[]))
in (FStar_Absyn_Syntax.mk_Exp_app _109_897 None p))
in (FStar_Util.Inr ((x.FStar_Absyn_Syntax.v, proj)))::[])
end))
end)
end))))
in (FStar_All.pipe_right _109_898 FStar_List.flatten))
in (let ntps = (FStar_List.length tps)
in (let _109_936 = (FStar_All.pipe_right formals (FStar_List.mapi (fun i ax -> (match ((Prims.fst ax)) with
| FStar_Util.Inl (a) -> begin
(let _43_2274 = (FStar_Absyn_Util.mk_field_projector_name lid a i)
in (match (_43_2274) with
| (field_name, _43_2273) -> begin
(let kk = (let _109_902 = (let _109_901 = (FStar_Absyn_Util.subst_kind subst a.FStar_Absyn_Syntax.sort)
in (binders, _109_901))
in (FStar_Absyn_Syntax.mk_Kind_arrow _109_902 p))
in (let _109_905 = (let _109_904 = (let _109_903 = (FStar_Absyn_Syntax.range_of_lid field_name)
in (field_name, [], kk, [], [], (FStar_Absyn_Syntax.Logic)::(FStar_Absyn_Syntax.Projector ((lid, FStar_Util.Inl (a.FStar_Absyn_Syntax.v))))::[], _109_903))
in FStar_Absyn_Syntax.Sig_tycon (_109_904))
in (_109_905)::[]))
end))
end
| FStar_Util.Inr (x) -> begin
(let _43_2281 = (FStar_Absyn_Util.mk_field_projector_name lid x i)
in (match (_43_2281) with
| (field_name, _43_2280) -> begin
(let t = (let _109_908 = (let _109_907 = (let _109_906 = (FStar_Absyn_Util.subst_typ subst x.FStar_Absyn_Syntax.sort)
in (FStar_Absyn_Util.total_comp _109_906 p))
in (binders, _109_907))
in (FStar_Absyn_Syntax.mk_Typ_fun _109_908 None p))
in (let quals = (fun q -> (match (((not (env.FStar_Parser_DesugarEnv.iface)) || env.FStar_Parser_DesugarEnv.admitted_iface)) with
| true -> begin
(FStar_Absyn_Syntax.Assumption)::q
end
| false -> begin
q
end))
in (let quals = (quals ((FStar_Absyn_Syntax.Logic)::(FStar_Absyn_Syntax.Projector ((lid, FStar_Util.Inr (x.FStar_Absyn_Syntax.v))))::[]))
in (let impl = (match ((((let _109_911 = (FStar_Parser_DesugarEnv.current_module env)
in (FStar_Absyn_Syntax.lid_equals FStar_Absyn_Const.prims_lid _109_911)) || (fvq <> FStar_Absyn_Syntax.Data_ctor)) || (FStar_ST.read FStar_Options.__temp_no_proj))) with
| true -> begin
[]
end
| false -> begin
(let projection = (FStar_Absyn_Util.gen_bvar FStar_Absyn_Syntax.tun)
in (let as_imp = (fun _43_15 -> (match (_43_15) with
| Some (FStar_Absyn_Syntax.Implicit) -> begin
true
end
| _43_2291 -> begin
false
end))
in (let arg_pats = (let _109_926 = (FStar_All.pipe_right formals (FStar_List.mapi (fun j by -> (match (by) with
| (FStar_Util.Inl (_43_2296), imp) -> begin
(match ((j < ntps)) with
| true -> begin
[]
end
| false -> begin
(let _109_919 = (let _109_918 = (let _109_917 = (let _109_916 = (FStar_Absyn_Util.gen_bvar FStar_Absyn_Syntax.kun)
in FStar_Absyn_Syntax.Pat_tvar (_109_916))
in (pos _109_917))
in (_109_918, (as_imp imp)))
in (_109_919)::[])
end)
end
| (FStar_Util.Inr (_43_2301), imp) -> begin
(match ((i = j)) with
| true -> begin
(let _109_921 = (let _109_920 = (pos (FStar_Absyn_Syntax.Pat_var (projection)))
in (_109_920, (as_imp imp)))
in (_109_921)::[])
end
| false -> begin
(let _109_925 = (let _109_924 = (let _109_923 = (let _109_922 = (FStar_Absyn_Util.gen_bvar FStar_Absyn_Syntax.tun)
in FStar_Absyn_Syntax.Pat_wild (_109_922))
in (pos _109_923))
in (_109_924, (as_imp imp)))
in (_109_925)::[])
end)
end))))
in (FStar_All.pipe_right _109_926 FStar_List.flatten))
in (let pat = (let _109_931 = (let _109_929 = (let _109_928 = (let _109_927 = (FStar_Absyn_Util.fv lid)
in (_109_927, Some (fvq), arg_pats))
in FStar_Absyn_Syntax.Pat_cons (_109_928))
in (FStar_All.pipe_right _109_929 pos))
in (let _109_930 = (FStar_Absyn_Util.bvar_to_exp projection)
in (_109_931, None, _109_930)))
in (let body = (FStar_Absyn_Syntax.mk_Exp_match (arg_exp, (pat)::[]) None p)
in (let imp = (let _109_932 = (FStar_Absyn_Syntax.range_of_lid field_name)
in (FStar_Absyn_Syntax.mk_Exp_abs (binders, body) None _109_932))
in (let lb = {FStar_Absyn_Syntax.lbname = FStar_Util.Inr (field_name); FStar_Absyn_Syntax.lbtyp = FStar_Absyn_Syntax.tun; FStar_Absyn_Syntax.lbeff = FStar_Absyn_Const.effect_Tot_lid; FStar_Absyn_Syntax.lbdef = imp}
in (FStar_Absyn_Syntax.Sig_let (((false, (lb)::[]), p, [], quals)))::[])))))))
end)
in (let _109_935 = (let _109_934 = (let _109_933 = (FStar_Absyn_Syntax.range_of_lid field_name)
in (field_name, t, quals, _109_933))
in FStar_Absyn_Syntax.Sig_val_decl (_109_934))
in (_109_935)::impl)))))
end))
end))))
in (FStar_All.pipe_right _109_936 FStar_List.flatten)))))))))))))
end))

let mk_data_projectors = (fun env _43_18 -> (match (_43_18) with
| FStar_Absyn_Syntax.Sig_datacon (lid, t, tycon, quals, _43_2318, _43_2320) when (not ((FStar_Absyn_Syntax.lid_equals lid FStar_Absyn_Const.lexcons_lid))) -> begin
(let refine_domain = (match ((FStar_All.pipe_right quals (FStar_Util.for_some (fun _43_16 -> (match (_43_16) with
| FStar_Absyn_Syntax.RecordConstructor (_43_2325) -> begin
true
end
| _43_2328 -> begin
false
end))))) with
| true -> begin
false
end
| false -> begin
(let _43_2334 = tycon
in (match (_43_2334) with
| (l, _43_2331, _43_2333) -> begin
(match ((FStar_Parser_DesugarEnv.find_all_datacons env l)) with
| Some (l) -> begin
((FStar_List.length l) > 1)
end
| _43_2338 -> begin
true
end)
end))
end)
in (match ((FStar_Absyn_Util.function_formals t)) with
| Some (formals, cod) -> begin
(let cod = (FStar_Absyn_Util.comp_result cod)
in (let qual = (match ((FStar_Util.find_map quals (fun _43_17 -> (match (_43_17) with
| FStar_Absyn_Syntax.RecordConstructor (fns) -> begin
Some (FStar_Absyn_Syntax.Record_ctor ((lid, fns)))
end
| _43_2349 -> begin
None
end)))) with
| None -> begin
FStar_Absyn_Syntax.Data_ctor
end
| Some (q) -> begin
q
end)
in (mk_indexed_projectors qual refine_domain env tycon lid formals cod)))
end
| _43_2355 -> begin
[]
end))
end
| _43_2357 -> begin
[]
end))

let rec desugar_tycon = (fun env rng quals tcs -> (let tycon_id = (fun _43_19 -> (match (_43_19) with
| (FStar_Parser_AST.TyconAbstract (id, _, _)) | (FStar_Parser_AST.TyconAbbrev (id, _, _, _)) | (FStar_Parser_AST.TyconRecord (id, _, _, _)) | (FStar_Parser_AST.TyconVariant (id, _, _, _)) -> begin
id
end))
in (let binder_to_term = (fun b -> (match (b.FStar_Parser_AST.b) with
| (FStar_Parser_AST.Annotated (x, _)) | (FStar_Parser_AST.Variable (x)) -> begin
(let _109_956 = (let _109_955 = (FStar_Absyn_Syntax.lid_of_ids ((x)::[]))
in FStar_Parser_AST.Var (_109_955))
in (FStar_Parser_AST.mk_term _109_956 x.FStar_Absyn_Syntax.idRange FStar_Parser_AST.Expr))
end
| (FStar_Parser_AST.TAnnotated (a, _)) | (FStar_Parser_AST.TVariable (a)) -> begin
(FStar_Parser_AST.mk_term (FStar_Parser_AST.Tvar (a)) a.FStar_Absyn_Syntax.idRange FStar_Parser_AST.Type)
end
| FStar_Parser_AST.NoName (t) -> begin
t
end))
in (let tot = (FStar_Parser_AST.mk_term (FStar_Parser_AST.Name (FStar_Absyn_Const.effect_Tot_lid)) rng FStar_Parser_AST.Expr)
in (let with_constructor_effect = (fun t -> (FStar_Parser_AST.mk_term (FStar_Parser_AST.App ((tot, t, FStar_Parser_AST.Nothing))) t.FStar_Parser_AST.range t.FStar_Parser_AST.level))
in (let apply_binders = (fun t binders -> (FStar_List.fold_left (fun out b -> (let _109_967 = (let _109_966 = (let _109_965 = (binder_to_term b)
in (out, _109_965, FStar_Parser_AST.Nothing))
in FStar_Parser_AST.App (_109_966))
in (FStar_Parser_AST.mk_term _109_967 out.FStar_Parser_AST.range out.FStar_Parser_AST.level))) t binders))
in (let tycon_record_as_variant = (fun _43_20 -> (match (_43_20) with
| FStar_Parser_AST.TyconRecord (id, parms, kopt, fields) -> begin
(let constrName = (FStar_Absyn_Syntax.mk_ident ((Prims.strcat "Mk" id.FStar_Absyn_Syntax.idText), id.FStar_Absyn_Syntax.idRange))
in (let mfields = (FStar_List.map (fun _43_2429 -> (match (_43_2429) with
| (x, t) -> begin
(let _109_973 = (let _109_972 = (let _109_971 = (FStar_Absyn_Util.mangle_field_name x)
in (_109_971, t))
in FStar_Parser_AST.Annotated (_109_972))
in (FStar_Parser_AST.mk_binder _109_973 x.FStar_Absyn_Syntax.idRange FStar_Parser_AST.Expr None))
end)) fields)
in (let result = (let _109_976 = (let _109_975 = (let _109_974 = (FStar_Absyn_Syntax.lid_of_ids ((id)::[]))
in FStar_Parser_AST.Var (_109_974))
in (FStar_Parser_AST.mk_term _109_975 id.FStar_Absyn_Syntax.idRange FStar_Parser_AST.Type))
in (apply_binders _109_976 parms))
in (let constrTyp = (FStar_Parser_AST.mk_term (FStar_Parser_AST.Product ((mfields, (with_constructor_effect result)))) id.FStar_Absyn_Syntax.idRange FStar_Parser_AST.Type)
in (let _109_978 = (FStar_All.pipe_right fields (FStar_List.map (fun _43_2436 -> (match (_43_2436) with
| (x, _43_2435) -> begin
(FStar_Parser_DesugarEnv.qualify env x)
end))))
in (FStar_Parser_AST.TyconVariant ((id, parms, kopt, ((constrName, Some (constrTyp), false))::[])), _109_978))))))
end
| _43_2438 -> begin
(FStar_All.failwith "impossible")
end))
in (let desugar_abstract_tc = (fun quals _env mutuals _43_21 -> (match (_43_21) with
| FStar_Parser_AST.TyconAbstract (id, binders, kopt) -> begin
(let _43_2452 = (typars_of_binders _env binders)
in (match (_43_2452) with
| (_env', typars) -> begin
(let k = (match (kopt) with
| None -> begin
FStar_Absyn_Syntax.kun
end
| Some (k) -> begin
(desugar_kind _env' k)
end)
in (let tconstr = (let _109_989 = (let _109_988 = (let _109_987 = (FStar_Absyn_Syntax.lid_of_ids ((id)::[]))
in FStar_Parser_AST.Var (_109_987))
in (FStar_Parser_AST.mk_term _109_988 id.FStar_Absyn_Syntax.idRange FStar_Parser_AST.Type))
in (apply_binders _109_989 binders))
in (let qlid = (FStar_Parser_DesugarEnv.qualify _env id)
in (let se = FStar_Absyn_Syntax.Sig_tycon ((qlid, typars, k, mutuals, [], quals, rng))
in (let _env = (FStar_Parser_DesugarEnv.push_rec_binding _env (FStar_Parser_DesugarEnv.Binding_tycon (qlid)))
in (let _env2 = (FStar_Parser_DesugarEnv.push_rec_binding _env' (FStar_Parser_DesugarEnv.Binding_tycon (qlid)))
in (_env, (_env2, typars), se, tconstr)))))))
end))
end
| _43_2463 -> begin
(FStar_All.failwith "Unexpected tycon")
end))
in (let push_tparam = (fun env _43_22 -> (match (_43_22) with
| (FStar_Util.Inr (x), _43_2470) -> begin
(FStar_Parser_DesugarEnv.push_bvvdef env x.FStar_Absyn_Syntax.v)
end
| (FStar_Util.Inl (a), _43_2475) -> begin
(FStar_Parser_DesugarEnv.push_btvdef env a.FStar_Absyn_Syntax.v)
end))
in (let push_tparams = (FStar_List.fold_left push_tparam)
in (match (tcs) with
| FStar_Parser_AST.TyconAbstract (_43_2479)::[] -> begin
(let tc = (FStar_List.hd tcs)
in (let _43_2490 = (desugar_abstract_tc quals env [] tc)
in (match (_43_2490) with
| (_43_2484, _43_2486, se, _43_2489) -> begin
(let env = (FStar_Parser_DesugarEnv.push_sigelt env se)
in (env, (se)::[]))
end)))
end
| FStar_Parser_AST.TyconAbbrev (id, binders, kopt, t)::[] -> begin
(let _43_2501 = (typars_of_binders env binders)
in (match (_43_2501) with
| (env', typars) -> begin
(let k = (match (kopt) with
| None -> begin
(match ((FStar_Util.for_some (fun _43_23 -> (match (_43_23) with
| FStar_Absyn_Syntax.Effect -> begin
true
end
| _43_2506 -> begin
false
end)) quals)) with
| true -> begin
FStar_Absyn_Syntax.mk_Kind_effect
end
| false -> begin
FStar_Absyn_Syntax.kun
end)
end
| Some (k) -> begin
(desugar_kind env' k)
end)
in (let t0 = t
in (let quals = (match ((FStar_All.pipe_right quals (FStar_Util.for_some (fun _43_24 -> (match (_43_24) with
| FStar_Absyn_Syntax.Logic -> begin
true
end
| _43_2514 -> begin
false
end))))) with
| true -> begin
quals
end
| false -> begin
(match ((t0.FStar_Parser_AST.level = FStar_Parser_AST.Formula)) with
| true -> begin
(FStar_Absyn_Syntax.Logic)::quals
end
| false -> begin
quals
end)
end)
in (let se = (match ((FStar_All.pipe_right quals (FStar_List.contains FStar_Absyn_Syntax.Effect))) with
| true -> begin
(let c = (desugar_comp t.FStar_Parser_AST.range false env' t)
in (let _109_1001 = (let _109_1000 = (FStar_Parser_DesugarEnv.qualify env id)
in (let _109_999 = (FStar_All.pipe_right quals (FStar_List.filter (fun _43_25 -> (match (_43_25) with
| FStar_Absyn_Syntax.Effect -> begin
false
end
| _43_2520 -> begin
true
end))))
in (_109_1000, typars, c, _109_999, rng)))
in FStar_Absyn_Syntax.Sig_effect_abbrev (_109_1001)))
end
| false -> begin
(let t = (desugar_typ env' t)
in (let _109_1003 = (let _109_1002 = (FStar_Parser_DesugarEnv.qualify env id)
in (_109_1002, typars, k, t, quals, rng))
in FStar_Absyn_Syntax.Sig_typ_abbrev (_109_1003)))
end)
in (let env = (FStar_Parser_DesugarEnv.push_sigelt env se)
in (env, (se)::[]))))))
end))
end
| FStar_Parser_AST.TyconRecord (_43_2525)::[] -> begin
(let trec = (FStar_List.hd tcs)
in (let _43_2531 = (tycon_record_as_variant trec)
in (match (_43_2531) with
| (t, fs) -> begin
(desugar_tycon env rng ((FStar_Absyn_Syntax.RecordType (fs))::quals) ((t)::[]))
end)))
end
| _43_2535::_43_2533 -> begin
(let env0 = env
in (let mutuals = (FStar_List.map (fun x -> (FStar_All.pipe_left (FStar_Parser_DesugarEnv.qualify env) (tycon_id x))) tcs)
in (let rec collect_tcs = (fun quals et tc -> (let _43_2546 = et
in (match (_43_2546) with
| (env, tcs) -> begin
(match (tc) with
| FStar_Parser_AST.TyconRecord (_43_2548) -> begin
(let trec = tc
in (let _43_2553 = (tycon_record_as_variant trec)
in (match (_43_2553) with
| (t, fs) -> begin
(collect_tcs ((FStar_Absyn_Syntax.RecordType (fs))::quals) (env, tcs) t)
end)))
end
| FStar_Parser_AST.TyconVariant (id, binders, kopt, constructors) -> begin
(let _43_2567 = (desugar_abstract_tc quals env mutuals (FStar_Parser_AST.TyconAbstract ((id, binders, kopt))))
in (match (_43_2567) with
| (env, (_43_2562, tps), se, tconstr) -> begin
(env, (FStar_Util.Inl ((se, tps, constructors, tconstr, quals)))::tcs)
end))
end
| FStar_Parser_AST.TyconAbbrev (id, binders, kopt, t) -> begin
(let _43_2581 = (desugar_abstract_tc quals env mutuals (FStar_Parser_AST.TyconAbstract ((id, binders, kopt))))
in (match (_43_2581) with
| (env, (_43_2576, tps), se, tconstr) -> begin
(env, (FStar_Util.Inr ((se, tps, t, quals)))::tcs)
end))
end
| _43_2583 -> begin
(FStar_All.failwith "Unrecognized mutual type definition")
end)
end)))
in (let _43_2586 = (FStar_List.fold_left (collect_tcs quals) (env, []) tcs)
in (match (_43_2586) with
| (env, tcs) -> begin
(let tcs = (FStar_List.rev tcs)
in (let sigelts = (FStar_All.pipe_right tcs (FStar_List.collect (fun _43_27 -> (match (_43_27) with
| FStar_Util.Inr (FStar_Absyn_Syntax.Sig_tycon (id, tpars, k, _43_2593, _43_2595, _43_2597, _43_2599), tps, t, quals) -> begin
(let env_tps = (push_tparams env tps)
in (let t = (desugar_typ env_tps t)
in (FStar_Absyn_Syntax.Sig_typ_abbrev ((id, tpars, k, t, [], rng)))::[]))
end
| FStar_Util.Inl (FStar_Absyn_Syntax.Sig_tycon (tname, tpars, k, mutuals, _43_2614, tags, _43_2617), tps, constrs, tconstr, quals) -> begin
(let tycon = (tname, tpars, k)
in (let env_tps = (push_tparams env tps)
in (let _43_2653 = (let _109_1022 = (FStar_All.pipe_right constrs (FStar_List.map (fun _43_2631 -> (match (_43_2631) with
| (id, topt, of_notation) -> begin
(let t = (match (of_notation) with
| true -> begin
(match (topt) with
| Some (t) -> begin
(FStar_Parser_AST.mk_term (FStar_Parser_AST.Product ((((FStar_Parser_AST.mk_binder (FStar_Parser_AST.NoName (t)) t.FStar_Parser_AST.range t.FStar_Parser_AST.level None))::[], tconstr))) t.FStar_Parser_AST.range t.FStar_Parser_AST.level)
end
| None -> begin
tconstr
end)
end
| false -> begin
(match (topt) with
| None -> begin
(FStar_All.failwith "Impossible")
end
| Some (t) -> begin
t
end)
end)
in (let t = (let _109_1014 = (FStar_Parser_DesugarEnv.default_total env_tps)
in (let _109_1013 = (close env_tps t)
in (desugar_typ _109_1014 _109_1013)))
in (let name = (FStar_Parser_DesugarEnv.qualify env id)
in (let quals = (FStar_All.pipe_right tags (FStar_List.collect (fun _43_26 -> (match (_43_26) with
| FStar_Absyn_Syntax.RecordType (fns) -> begin
(FStar_Absyn_Syntax.RecordConstructor (fns))::[]
end
| _43_2645 -> begin
[]
end))))
in (let _109_1021 = (let _109_1020 = (let _109_1019 = (let _109_1018 = (let _109_1017 = (FStar_List.map (fun _43_2650 -> (match (_43_2650) with
| (x, _43_2649) -> begin
(x, Some (FStar_Absyn_Syntax.Implicit))
end)) tps)
in (FStar_Absyn_Util.close_typ _109_1017 t))
in (FStar_All.pipe_right _109_1018 FStar_Absyn_Util.name_function_binders))
in (name, _109_1019, tycon, quals, mutuals, rng))
in FStar_Absyn_Syntax.Sig_datacon (_109_1020))
in (name, _109_1021))))))
end))))
in (FStar_All.pipe_left FStar_List.split _109_1022))
in (match (_43_2653) with
| (constrNames, constrs) -> begin
(FStar_Absyn_Syntax.Sig_tycon ((tname, tpars, k, mutuals, constrNames, tags, rng)))::constrs
end))))
end
| _43_2655 -> begin
(FStar_All.failwith "impossible")
end))))
in (let bundle = (let _109_1024 = (let _109_1023 = (FStar_List.collect FStar_Absyn_Util.lids_of_sigelt sigelts)
in (sigelts, quals, _109_1023, rng))
in FStar_Absyn_Syntax.Sig_bundle (_109_1024))
in (let env = (FStar_Parser_DesugarEnv.push_sigelt env0 bundle)
in (let data_ops = (FStar_All.pipe_right sigelts (FStar_List.collect (mk_data_projectors env)))
in (let discs = (FStar_All.pipe_right sigelts (FStar_List.collect (fun _43_28 -> (match (_43_28) with
| FStar_Absyn_Syntax.Sig_tycon (tname, tps, k, _43_2665, constrs, quals, _43_2669) -> begin
(mk_data_discriminators quals env tname tps k constrs)
end
| _43_2673 -> begin
[]
end))))
in (let ops = (FStar_List.append discs data_ops)
in (let env = (FStar_List.fold_left FStar_Parser_DesugarEnv.push_sigelt env ops)
in (env, (FStar_List.append ((bundle)::[]) ops))))))))))
end)))))
end
| [] -> begin
(FStar_All.failwith "impossible")
end)))))))))))

let desugar_binders = (fun env binders -> (let _43_2704 = (FStar_List.fold_left (fun _43_2682 b -> (match (_43_2682) with
| (env, binders) -> begin
(match ((desugar_binder env b)) with
| FStar_Util.Inl (Some (a), k) -> begin
(let _43_2691 = (FStar_Parser_DesugarEnv.push_local_tbinding env a)
in (match (_43_2691) with
| (env, a) -> begin
(let _109_1033 = (let _109_1032 = (FStar_Absyn_Syntax.t_binder (FStar_Absyn_Util.bvd_to_bvar_s a k))
in (_109_1032)::binders)
in (env, _109_1033))
end))
end
| FStar_Util.Inr (Some (x), t) -> begin
(let _43_2699 = (FStar_Parser_DesugarEnv.push_local_vbinding env x)
in (match (_43_2699) with
| (env, x) -> begin
(let _109_1035 = (let _109_1034 = (FStar_Absyn_Syntax.v_binder (FStar_Absyn_Util.bvd_to_bvar_s x t))
in (_109_1034)::binders)
in (env, _109_1035))
end))
end
| _43_2701 -> begin
(Prims.raise (FStar_Absyn_Syntax.Error (("Missing name in binder", b.FStar_Parser_AST.brange))))
end)
end)) (env, []) binders)
in (match (_43_2704) with
| (env, binders) -> begin
(env, (FStar_List.rev binders))
end)))

let rec desugar_decl = (fun env d -> (match (d.FStar_Parser_AST.d) with
| FStar_Parser_AST.Pragma (p) -> begin
(let se = FStar_Absyn_Syntax.Sig_pragma ((p, d.FStar_Parser_AST.drange))
in (env, (se)::[]))
end
| FStar_Parser_AST.Open (lid) -> begin
(let env = (FStar_Parser_DesugarEnv.push_namespace env lid)
in (env, []))
end
| FStar_Parser_AST.Tycon (qual, tcs) -> begin
(desugar_tycon env d.FStar_Parser_AST.drange qual tcs)
end
| FStar_Parser_AST.ToplevelLet (isrec, lets) -> begin
(match ((let _109_1041 = (let _109_1040 = (desugar_exp_maybe_top true env (FStar_Parser_AST.mk_term (FStar_Parser_AST.Let ((isrec, lets, (FStar_Parser_AST.mk_term (FStar_Parser_AST.Const (FStar_Absyn_Syntax.Const_unit)) d.FStar_Parser_AST.drange FStar_Parser_AST.Expr)))) d.FStar_Parser_AST.drange FStar_Parser_AST.Expr))
in (FStar_All.pipe_left FStar_Absyn_Util.compress_exp _109_1040))
in _109_1041.FStar_Absyn_Syntax.n)) with
| FStar_Absyn_Syntax.Exp_let (lbs, _43_2723) -> begin
(let lids = (FStar_All.pipe_right (Prims.snd lbs) (FStar_List.map (fun lb -> (match (lb.FStar_Absyn_Syntax.lbname) with
| FStar_Util.Inr (l) -> begin
l
end
| _43_2730 -> begin
(FStar_All.failwith "impossible")
end))))
in (let quals = (FStar_All.pipe_right (Prims.snd lbs) (FStar_List.collect (fun _43_29 -> (match (_43_29) with
| {FStar_Absyn_Syntax.lbname = FStar_Util.Inl (_43_2740); FStar_Absyn_Syntax.lbtyp = _43_2738; FStar_Absyn_Syntax.lbeff = _43_2736; FStar_Absyn_Syntax.lbdef = _43_2734} -> begin
[]
end
| {FStar_Absyn_Syntax.lbname = FStar_Util.Inr (l); FStar_Absyn_Syntax.lbtyp = _43_2748; FStar_Absyn_Syntax.lbeff = _43_2746; FStar_Absyn_Syntax.lbdef = _43_2744} -> begin
(FStar_Parser_DesugarEnv.lookup_letbinding_quals env l)
end))))
in (let s = FStar_Absyn_Syntax.Sig_let ((lbs, d.FStar_Parser_AST.drange, lids, quals))
in (let env = (FStar_Parser_DesugarEnv.push_sigelt env s)
in (env, (s)::[])))))
end
| _43_2756 -> begin
(FStar_All.failwith "Desugaring a let did not produce a let")
end)
end
| FStar_Parser_AST.Main (t) -> begin
(let e = (desugar_exp env t)
in (let se = FStar_Absyn_Syntax.Sig_main ((e, d.FStar_Parser_AST.drange))
in (env, (se)::[])))
end
| FStar_Parser_AST.Assume (atag, id, t) -> begin
(let f = (desugar_formula env t)
in (let _109_1047 = (let _109_1046 = (let _109_1045 = (let _109_1044 = (FStar_Parser_DesugarEnv.qualify env id)
in (_109_1044, f, (FStar_Absyn_Syntax.Assumption)::[], d.FStar_Parser_AST.drange))
in FStar_Absyn_Syntax.Sig_assume (_109_1045))
in (_109_1046)::[])
in (env, _109_1047)))
end
| FStar_Parser_AST.Val (quals, id, t) -> begin
(let t = (let _109_1048 = (close_fun env t)
in (desugar_typ env _109_1048))
in (let quals = (match ((env.FStar_Parser_DesugarEnv.iface && env.FStar_Parser_DesugarEnv.admitted_iface)) with
| true -> begin
(FStar_Absyn_Syntax.Assumption)::quals
end
| false -> begin
quals
end)
in (let se = (let _109_1050 = (let _109_1049 = (FStar_Parser_DesugarEnv.qualify env id)
in (_109_1049, t, quals, d.FStar_Parser_AST.drange))
in FStar_Absyn_Syntax.Sig_val_decl (_109_1050))
in (let env = (FStar_Parser_DesugarEnv.push_sigelt env se)
in (env, (se)::[])))))
end
| FStar_Parser_AST.Exception (id, None) -> begin
(let t = (FStar_Parser_DesugarEnv.fail_or env (FStar_Parser_DesugarEnv.try_lookup_typ_name env) FStar_Absyn_Const.exn_lid)
in (let l = (FStar_Parser_DesugarEnv.qualify env id)
in (let se = FStar_Absyn_Syntax.Sig_datacon ((l, t, (FStar_Absyn_Const.exn_lid, [], FStar_Absyn_Syntax.ktype), (FStar_Absyn_Syntax.ExceptionConstructor)::[], (FStar_Absyn_Const.exn_lid)::[], d.FStar_Parser_AST.drange))
in (let se' = FStar_Absyn_Syntax.Sig_bundle (((se)::[], (FStar_Absyn_Syntax.ExceptionConstructor)::[], (l)::[], d.FStar_Parser_AST.drange))
in (let env = (FStar_Parser_DesugarEnv.push_sigelt env se')
in (let data_ops = (mk_data_projectors env se)
in (let discs = (mk_data_discriminators [] env FStar_Absyn_Const.exn_lid [] FStar_Absyn_Syntax.ktype ((l)::[]))
in (let env = (FStar_List.fold_left FStar_Parser_DesugarEnv.push_sigelt env (FStar_List.append discs data_ops))
in (env, (FStar_List.append ((se')::discs) data_ops))))))))))
end
| FStar_Parser_AST.Exception (id, Some (term)) -> begin
(let t = (desugar_typ env term)
in (let t = (let _109_1055 = (let _109_1054 = (let _109_1051 = (FStar_Absyn_Syntax.null_v_binder t)
in (_109_1051)::[])
in (let _109_1053 = (let _109_1052 = (FStar_Parser_DesugarEnv.fail_or env (FStar_Parser_DesugarEnv.try_lookup_typ_name env) FStar_Absyn_Const.exn_lid)
in (FStar_Absyn_Syntax.mk_Total _109_1052))
in (_109_1054, _109_1053)))
in (FStar_Absyn_Syntax.mk_Typ_fun _109_1055 None d.FStar_Parser_AST.drange))
in (let l = (FStar_Parser_DesugarEnv.qualify env id)
in (let se = FStar_Absyn_Syntax.Sig_datacon ((l, t, (FStar_Absyn_Const.exn_lid, [], FStar_Absyn_Syntax.ktype), (FStar_Absyn_Syntax.ExceptionConstructor)::[], (FStar_Absyn_Const.exn_lid)::[], d.FStar_Parser_AST.drange))
in (let se' = FStar_Absyn_Syntax.Sig_bundle (((se)::[], (FStar_Absyn_Syntax.ExceptionConstructor)::[], (l)::[], d.FStar_Parser_AST.drange))
in (let env = (FStar_Parser_DesugarEnv.push_sigelt env se')
in (let data_ops = (mk_data_projectors env se)
in (let discs = (mk_data_discriminators [] env FStar_Absyn_Const.exn_lid [] FStar_Absyn_Syntax.ktype ((l)::[]))
in (let env = (FStar_List.fold_left FStar_Parser_DesugarEnv.push_sigelt env (FStar_List.append discs data_ops))
in (env, (FStar_List.append ((se')::discs) data_ops)))))))))))
end
| FStar_Parser_AST.KindAbbrev (id, binders, k) -> begin
(let _43_2809 = (desugar_binders env binders)
in (match (_43_2809) with
| (env_k, binders) -> begin
(let k = (desugar_kind env_k k)
in (let name = (FStar_Parser_DesugarEnv.qualify env id)
in (let se = FStar_Absyn_Syntax.Sig_kind_abbrev ((name, binders, k, d.FStar_Parser_AST.drange))
in (let env = (FStar_Parser_DesugarEnv.push_sigelt env se)
in (env, (se)::[])))))
end))
end
| FStar_Parser_AST.NewEffect (quals, FStar_Parser_AST.RedefineEffect (eff_name, eff_binders, defn)) -> begin
(let env0 = env
in (let _43_2825 = (desugar_binders env eff_binders)
in (match (_43_2825) with
| (env, binders) -> begin
(let defn = (desugar_typ env defn)
in (let _43_2829 = (FStar_Absyn_Util.head_and_args defn)
in (match (_43_2829) with
| (head, args) -> begin
(match (head.FStar_Absyn_Syntax.n) with
| FStar_Absyn_Syntax.Typ_const (eff) -> begin
(match ((FStar_Parser_DesugarEnv.try_lookup_effect_defn env eff.FStar_Absyn_Syntax.v)) with
| None -> begin
(let _109_1060 = (let _109_1059 = (let _109_1058 = (let _109_1057 = (let _109_1056 = (FStar_Absyn_Print.sli eff.FStar_Absyn_Syntax.v)
in (Prims.strcat "Effect " _109_1056))
in (Prims.strcat _109_1057 " not found"))
in (_109_1058, d.FStar_Parser_AST.drange))
in FStar_Absyn_Syntax.Error (_109_1059))
in (Prims.raise _109_1060))
end
| Some (ed) -> begin
(let subst = (FStar_Absyn_Util.subst_of_list ed.FStar_Absyn_Syntax.binders args)
in (let sub = (FStar_Absyn_Util.subst_typ subst)
in (let ed = (let _109_1077 = (FStar_Parser_DesugarEnv.qualify env0 eff_name)
in (let _109_1076 = (FStar_Absyn_Util.subst_kind subst ed.FStar_Absyn_Syntax.signature)
in (let _109_1075 = (sub ed.FStar_Absyn_Syntax.ret)
in (let _109_1074 = (sub ed.FStar_Absyn_Syntax.bind_wp)
in (let _109_1073 = (sub ed.FStar_Absyn_Syntax.bind_wlp)
in (let _109_1072 = (sub ed.FStar_Absyn_Syntax.if_then_else)
in (let _109_1071 = (sub ed.FStar_Absyn_Syntax.ite_wp)
in (let _109_1070 = (sub ed.FStar_Absyn_Syntax.ite_wlp)
in (let _109_1069 = (sub ed.FStar_Absyn_Syntax.wp_binop)
in (let _109_1068 = (sub ed.FStar_Absyn_Syntax.wp_as_type)
in (let _109_1067 = (sub ed.FStar_Absyn_Syntax.close_wp)
in (let _109_1066 = (sub ed.FStar_Absyn_Syntax.close_wp_t)
in (let _109_1065 = (sub ed.FStar_Absyn_Syntax.assert_p)
in (let _109_1064 = (sub ed.FStar_Absyn_Syntax.assume_p)
in (let _109_1063 = (sub ed.FStar_Absyn_Syntax.null_wp)
in (let _109_1062 = (sub ed.FStar_Absyn_Syntax.trivial)
in {FStar_Absyn_Syntax.mname = _109_1077; FStar_Absyn_Syntax.binders = binders; FStar_Absyn_Syntax.qualifiers = quals; FStar_Absyn_Syntax.signature = _109_1076; FStar_Absyn_Syntax.ret = _109_1075; FStar_Absyn_Syntax.bind_wp = _109_1074; FStar_Absyn_Syntax.bind_wlp = _109_1073; FStar_Absyn_Syntax.if_then_else = _109_1072; FStar_Absyn_Syntax.ite_wp = _109_1071; FStar_Absyn_Syntax.ite_wlp = _109_1070; FStar_Absyn_Syntax.wp_binop = _109_1069; FStar_Absyn_Syntax.wp_as_type = _109_1068; FStar_Absyn_Syntax.close_wp = _109_1067; FStar_Absyn_Syntax.close_wp_t = _109_1066; FStar_Absyn_Syntax.assert_p = _109_1065; FStar_Absyn_Syntax.assume_p = _109_1064; FStar_Absyn_Syntax.null_wp = _109_1063; FStar_Absyn_Syntax.trivial = _109_1062}))))))))))))))))
in (let se = FStar_Absyn_Syntax.Sig_new_effect ((ed, d.FStar_Parser_AST.drange))
in (let env = (FStar_Parser_DesugarEnv.push_sigelt env0 se)
in (env, (se)::[]))))))
end)
end
| _43_2841 -> begin
(let _109_1081 = (let _109_1080 = (let _109_1079 = (let _109_1078 = (FStar_Absyn_Print.typ_to_string head)
in (Prims.strcat _109_1078 " is not an effect"))
in (_109_1079, d.FStar_Parser_AST.drange))
in FStar_Absyn_Syntax.Error (_109_1080))
in (Prims.raise _109_1081))
end)
end)))
end)))
end
| FStar_Parser_AST.NewEffect (quals, FStar_Parser_AST.DefineEffect (eff_name, eff_binders, eff_kind, eff_decls)) -> begin
(let env0 = env
in (let env = (FStar_Parser_DesugarEnv.enter_monad_scope env eff_name)
in (let _43_2855 = (desugar_binders env eff_binders)
in (match (_43_2855) with
| (env, binders) -> begin
(let eff_k = (desugar_kind env eff_kind)
in (let _43_2866 = (FStar_All.pipe_right eff_decls (FStar_List.fold_left (fun _43_2859 decl -> (match (_43_2859) with
| (env, out) -> begin
(let _43_2863 = (desugar_decl env decl)
in (match (_43_2863) with
| (env, ses) -> begin
(let _109_1085 = (let _109_1084 = (FStar_List.hd ses)
in (_109_1084)::out)
in (env, _109_1085))
end))
end)) (env, [])))
in (match (_43_2866) with
| (env, decls) -> begin
(let decls = (FStar_List.rev decls)
in (let lookup = (fun s -> (match ((let _109_1089 = (let _109_1088 = (FStar_Absyn_Syntax.mk_ident (s, d.FStar_Parser_AST.drange))
in (FStar_Parser_DesugarEnv.qualify env _109_1088))
in (FStar_Parser_DesugarEnv.try_resolve_typ_abbrev env _109_1089))) with
| None -> begin
(Prims.raise (FStar_Absyn_Syntax.Error (((Prims.strcat (Prims.strcat (Prims.strcat "Monad " eff_name.FStar_Absyn_Syntax.idText) " expects definition of ") s), d.FStar_Parser_AST.drange))))
end
| Some (t) -> begin
t
end))
in (let ed = (let _109_1104 = (FStar_Parser_DesugarEnv.qualify env0 eff_name)
in (let _109_1103 = (lookup "return")
in (let _109_1102 = (lookup "bind_wp")
in (let _109_1101 = (lookup "bind_wlp")
in (let _109_1100 = (lookup "if_then_else")
in (let _109_1099 = (lookup "ite_wp")
in (let _109_1098 = (lookup "ite_wlp")
in (let _109_1097 = (lookup "wp_binop")
in (let _109_1096 = (lookup "wp_as_type")
in (let _109_1095 = (lookup "close_wp")
in (let _109_1094 = (lookup "close_wp_t")
in (let _109_1093 = (lookup "assert_p")
in (let _109_1092 = (lookup "assume_p")
in (let _109_1091 = (lookup "null_wp")
in (let _109_1090 = (lookup "trivial")
in {FStar_Absyn_Syntax.mname = _109_1104; FStar_Absyn_Syntax.binders = binders; FStar_Absyn_Syntax.qualifiers = quals; FStar_Absyn_Syntax.signature = eff_k; FStar_Absyn_Syntax.ret = _109_1103; FStar_Absyn_Syntax.bind_wp = _109_1102; FStar_Absyn_Syntax.bind_wlp = _109_1101; FStar_Absyn_Syntax.if_then_else = _109_1100; FStar_Absyn_Syntax.ite_wp = _109_1099; FStar_Absyn_Syntax.ite_wlp = _109_1098; FStar_Absyn_Syntax.wp_binop = _109_1097; FStar_Absyn_Syntax.wp_as_type = _109_1096; FStar_Absyn_Syntax.close_wp = _109_1095; FStar_Absyn_Syntax.close_wp_t = _109_1094; FStar_Absyn_Syntax.assert_p = _109_1093; FStar_Absyn_Syntax.assume_p = _109_1092; FStar_Absyn_Syntax.null_wp = _109_1091; FStar_Absyn_Syntax.trivial = _109_1090})))))))))))))))
in (let se = FStar_Absyn_Syntax.Sig_new_effect ((ed, d.FStar_Parser_AST.drange))
in (let env = (FStar_Parser_DesugarEnv.push_sigelt env0 se)
in (env, (se)::[]))))))
end)))
end))))
end
| FStar_Parser_AST.SubEffect (l) -> begin
(let lookup = (fun l -> (match ((FStar_Parser_DesugarEnv.try_lookup_effect_name env l)) with
| None -> begin
(let _109_1111 = (let _109_1110 = (let _109_1109 = (let _109_1108 = (let _109_1107 = (FStar_Absyn_Print.sli l)
in (Prims.strcat "Effect name " _109_1107))
in (Prims.strcat _109_1108 " not found"))
in (_109_1109, d.FStar_Parser_AST.drange))
in FStar_Absyn_Syntax.Error (_109_1110))
in (Prims.raise _109_1111))
end
| Some (l) -> begin
l
end))
in (let src = (lookup l.FStar_Parser_AST.msource)
in (let dst = (lookup l.FStar_Parser_AST.mdest)
in (let lift = (desugar_typ env l.FStar_Parser_AST.lift_op)
in (let se = FStar_Absyn_Syntax.Sig_sub_effect (({FStar_Absyn_Syntax.source = src; FStar_Absyn_Syntax.target = dst; FStar_Absyn_Syntax.lift = lift}, d.FStar_Parser_AST.drange))
in (env, (se)::[]))))))
end))

let desugar_decls = (fun env decls -> (FStar_List.fold_left (fun _43_2891 d -> (match (_43_2891) with
| (env, sigelts) -> begin
(let _43_2895 = (desugar_decl env d)
in (match (_43_2895) with
| (env, se) -> begin
(env, (FStar_List.append sigelts se))
end))
end)) (env, []) decls))

let open_prims_all = ((FStar_Parser_AST.mk_decl (FStar_Parser_AST.Open (FStar_Absyn_Const.prims_lid)) FStar_Absyn_Syntax.dummyRange))::((FStar_Parser_AST.mk_decl (FStar_Parser_AST.Open (FStar_Absyn_Const.all_lid)) FStar_Absyn_Syntax.dummyRange))::[]

let desugar_modul_common = (fun curmod env m -> (let open_ns = (fun mname d -> (let d = (match (((FStar_List.length mname.FStar_Absyn_Syntax.ns) <> 0)) with
| true -> begin
(let _109_1128 = (let _109_1127 = (let _109_1125 = (FStar_Absyn_Syntax.lid_of_ids mname.FStar_Absyn_Syntax.ns)
in FStar_Parser_AST.Open (_109_1125))
in (let _109_1126 = (FStar_Absyn_Syntax.range_of_lid mname)
in (FStar_Parser_AST.mk_decl _109_1127 _109_1126)))
in (_109_1128)::d)
end
| false -> begin
d
end)
in d))
in (let env = (match (curmod) with
| None -> begin
env
end
| Some (prev_mod, _43_2906) -> begin
(FStar_Parser_DesugarEnv.finish_module_or_interface env prev_mod)
end)
in (let _43_2923 = (match (m) with
| FStar_Parser_AST.Interface (mname, decls, admitted) -> begin
(let _109_1130 = (FStar_Parser_DesugarEnv.prepare_module_or_interface true admitted env mname)
in (let _109_1129 = (open_ns mname decls)
in (_109_1130, mname, _109_1129, true)))
end
| FStar_Parser_AST.Module (mname, decls) -> begin
(let _109_1132 = (FStar_Parser_DesugarEnv.prepare_module_or_interface false false env mname)
in (let _109_1131 = (open_ns mname decls)
in (_109_1132, mname, _109_1131, false)))
end)
in (match (_43_2923) with
| (env, mname, decls, intf) -> begin
(let _43_2926 = (desugar_decls env decls)
in (match (_43_2926) with
| (env, sigelts) -> begin
(let modul = {FStar_Absyn_Syntax.name = mname; FStar_Absyn_Syntax.declarations = sigelts; FStar_Absyn_Syntax.exports = []; FStar_Absyn_Syntax.is_interface = intf; FStar_Absyn_Syntax.is_deserialized = false}
in (env, modul))
end))
end)))))

let desugar_partial_modul = (fun curmod env m -> (let m = (match ((FStar_ST.read FStar_Options.interactive_fsi)) with
| true -> begin
(match (m) with
| FStar_Parser_AST.Module (mname, decls) -> begin
(let _109_1139 = (let _109_1138 = (let _109_1137 = (FStar_ST.read FStar_Options.admit_fsi)
in (FStar_Util.for_some (fun m -> (m = mname.FStar_Absyn_Syntax.str)) _109_1137))
in (mname, decls, _109_1138))
in FStar_Parser_AST.Interface (_109_1139))
end
| FStar_Parser_AST.Interface (mname, _43_2938, _43_2940) -> begin
(FStar_All.failwith (Prims.strcat "Impossible: " mname.FStar_Absyn_Syntax.ident.FStar_Absyn_Syntax.idText))
end)
end
| false -> begin
m
end)
in (desugar_modul_common curmod env m)))

let desugar_modul = (fun env m -> (let _43_2948 = (desugar_modul_common None env m)
in (match (_43_2948) with
| (env, modul) -> begin
(let env = (FStar_Parser_DesugarEnv.finish_module_or_interface env modul)
in (let _43_2950 = (match ((FStar_Options.should_dump modul.FStar_Absyn_Syntax.name.FStar_Absyn_Syntax.str)) with
| true -> begin
(let _109_1144 = (FStar_Absyn_Print.modul_to_string modul)
in (FStar_Util.fprint1 "%s\n" _109_1144))
end
| false -> begin
()
end)
in (env, modul)))
end)))

let desugar_file = (fun env f -> (let _43_2963 = (FStar_List.fold_left (fun _43_2956 m -> (match (_43_2956) with
| (env, mods) -> begin
(let _43_2960 = (desugar_modul env m)
in (match (_43_2960) with
| (env, m) -> begin
(env, (m)::mods)
end))
end)) (env, []) f)
in (match (_43_2963) with
| (env, mods) -> begin
(env, (FStar_List.rev mods))
end)))

let add_modul_to_env = (fun m en -> (let en = (FStar_Parser_DesugarEnv.prepare_module_or_interface false false en m.FStar_Absyn_Syntax.name)
in (let en = (FStar_List.fold_left FStar_Parser_DesugarEnv.push_sigelt (let _43_2967 = en
in {FStar_Parser_DesugarEnv.curmodule = Some (m.FStar_Absyn_Syntax.name); FStar_Parser_DesugarEnv.modules = _43_2967.FStar_Parser_DesugarEnv.modules; FStar_Parser_DesugarEnv.open_namespaces = _43_2967.FStar_Parser_DesugarEnv.open_namespaces; FStar_Parser_DesugarEnv.sigaccum = _43_2967.FStar_Parser_DesugarEnv.sigaccum; FStar_Parser_DesugarEnv.localbindings = _43_2967.FStar_Parser_DesugarEnv.localbindings; FStar_Parser_DesugarEnv.recbindings = _43_2967.FStar_Parser_DesugarEnv.recbindings; FStar_Parser_DesugarEnv.phase = _43_2967.FStar_Parser_DesugarEnv.phase; FStar_Parser_DesugarEnv.sigmap = _43_2967.FStar_Parser_DesugarEnv.sigmap; FStar_Parser_DesugarEnv.default_result_effect = _43_2967.FStar_Parser_DesugarEnv.default_result_effect; FStar_Parser_DesugarEnv.iface = _43_2967.FStar_Parser_DesugarEnv.iface; FStar_Parser_DesugarEnv.admitted_iface = _43_2967.FStar_Parser_DesugarEnv.admitted_iface}) m.FStar_Absyn_Syntax.exports)
in (FStar_Parser_DesugarEnv.finish_module_or_interface en m))))




