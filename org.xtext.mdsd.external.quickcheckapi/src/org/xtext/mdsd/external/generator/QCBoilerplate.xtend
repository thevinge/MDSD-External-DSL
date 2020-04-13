package org.xtext.mdsd.external.generator

class QCBoilerplate {
	def CharSequence initHttpModule() {
		'''
		module InternalHttp =
		struct
		  let get ?(header = "") url =
		    let r = Buffer.create 16384 in
		    let c = Curl.init () in
		    set_url c url;
		    set_httpheader c [header];
		    set_writefunction c (fun s -> Buffer.add_string r s; String.length s);
		    perform c;
		    let code = get_responsecode c in
		    cleanup c;
		    (code, Buffer.contents r)
		
		  let post ?(header = "") (* ?(content_type = "text/html") *) url data =
		    let r = Buffer.create 16384 in
		    let c = Curl.init () in
		    set_url c url;
		    set_post c true;
		    set_httpheader c [header];
		    set_writefunction c (fun s -> Buffer.add_string r s; String.length s);
		    set_postfields c data;
		    set_postfieldsize c (String.length data);
		    perform c;
		    let code = get_responsecode c in
		    cleanup c;
		    (code, Buffer.contents r)
		
		  let put ?(header = "") url data =
		    let pos = ref 0
		    and len = String.length data in
		    let rf cnt =
		      let can_send = len - !pos in
		      let to_send = if can_send > cnt then cnt else can_send in
		      let r = String.sub data !pos to_send in
		      pos := !pos + to_send; r 
		    and r = Buffer.create 16384 in
		    let c = Curl.init () in
		    set_url c url;
		    set_put c true;
		    set_upload c true;
		    set_readfunction c rf;
		    set_httpheader c [header];
		    set_writefunction c (fun s -> Buffer.add_string r s; String.length s);
		    (*set_postfields c data;
		      set_postfieldsize c (String.length data);*)
		    perform c;
		    let code = get_responsecode c in
		    cleanup c;
		    (code, Buffer.contents r)
		
		  let patch ?(header = "") url data =
		    let r = Buffer.create 16384 in
		    let c = Curl.init () in
		    set_customrequest c "PATCH";
		    set_url c url;
		    set_httpheader c [header];
		    set_writefunction c (fun s -> Buffer.add_string r s; String.length s);
		    perform c;
		    let code = get_responsecode c in
		    cleanup c;
		    (code, Buffer.contents r)
		
		  let delete ?(header = "") url =
		    let r = Buffer.create 16384 in
		    let c = Curl.init () in
		    set_customrequest c "DELETE";
		    set_url c url;
		    set_httpheader c [header];
		    set_writefunction c (fun s -> Buffer.add_string r s; String.length s);
		    perform c;
		    let code = get_responsecode c in
		    cleanup c;
		    (code, Buffer.contents r)
		end
		
		module Http =
		struct
		  (* Http Headers *)
		  let get_header = "Content-Type:application/json; "
		  let post_header = "Content-Type:application/json"
		  let put_header = "Content-Type:application/json"
		  let patch_header = "Content-Type:application/json"
		  let delete_header = "Content-Type:application/json"
		
		  let get ?(header = get_header) url =
		    let c,r = InternalHttp.get ~header:header url in
		    (c, Yojson.Basic.from_string r)
		  let rawpost ?(header = post_header) url data =
		    let c,r = InternalHttp.post ~header:header url data in
		    (c,r)
		  let post ?(header = post_header) url data =
		    let c,r = InternalHttp.post ~header:header url data in
		    (c, Yojson.Basic.from_string r)
		  let put ?(header = put_header) url data =
		    let c,r = InternalHttp.put ~header:header url data in
		    (c, Yojson.Basic.from_string r)
		  let patch ?(header = patch_header) url data =
		    let c,r = InternalHttp.patch ~header:header url data in
		    (c, Yojson.Basic.from_string r)
		  let delete ?(header = delete_header) url =
		    let c,r = InternalHttp.delete ~header:header url in
		    (c, r)
		
		end
		
		'''
	}
	
	def CharSequence initUtilities(){
		'''
		  (* Functions *)
		  (* Recursively drops n heads of a list and returns the rest of the list *)
		  let rec drop n h = if n == 0 then h else (drop (n-1) (match h with
		      | a::b -> b
		      | [] -> []))

		  (* basically this https://en.wikipedia.org/wiki/De_Bruijn_index *)
		  let lookupItem ix state = List.hd (drop (ix mod List.length state) (List.rev state))

		  let lookupSutItem ix sut = List.hd (drop (ix mod List.length sut) (List.rev sut))

		  let checkInvariant state sut = List.length state = List.length !sut

		  let rec remove_item pos list = match (list, pos) with
		    | ([], _) -> []
		    | (head::tail, 0) -> tail
		    | (head::tail,_) -> [head]@(remove_item (pos-1) tail)
		  
		  (* Wanting to get the index of the id back, length of list will always start at 1 for a given element but the first element is at index 0*)
		  let getPos ix list = ((List.length list - 1) - (ix mod List.length list))
		'''
	}
	
	def CharSequence initExternals() {
		'''
		«combine()»
		
		«extractId()»
		
		«cleanup()»
		'''
	}
	
	private def CharSequence combine() {
		'''
		(* Implement this method to combine your state and id *)
		let combine_state_id stateItem id =
			let combined = ... in
			
			
			combined
			
		'''
	}
	
	private def CharSequence extractId() {
		'''
		(* Implement this method to extract your id from a json body *)
		let extractIdFromContent (content:Yojson.Basic.t) : string =
			let extracted = ... in
			
			extracted
		'''
	}
	
	private def CharSequence cleanup() {
		'''
		(* Implement this method to cleanup after each test *)
		let afterTestcleanup =
			...
		'''
	}
	
	
	
}