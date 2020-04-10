package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Test

class QCRunCmd {
	def initRun_cmd(Test test ) {
		'''
		let run_cmd cmd state sut = match cmd with
		    | Get ix -> if (checkInvariant state sut) then 
		                   let id = lookupSutItem ix !sut in
		                  let code,content = Http.get (getUrl ^ id) in
		                  let extractedState = lookupItem ix state in
		                    let stateJson = Yojson.Basic.from_string extractedState in
		                    let sutJson = Yojson.Basic.from_string ("{\"id\": " ^ id ^ "}") in
		                    let combinedJson = Yojson.Basic.Util.combine stateJson sutJson in
		                  String.compare (Yojson.Basic.to_string content) (Yojson.Basic.to_string combinedJson) == 0
		                else
		                  false
		    | Create -> let code,content = Http.post (createUrl) "{\"name\": \"bar\"}" in
		                (* Get contents id and add it to sut *)
		                let id = content |> member "id" |> to_int in 
		                  sut := !sut@[string_of_int id];
		                true
		    | Delete ix -> if (checkInvariant state sut) then (
		                     let id = lookupSutItem ix !sut in
		                     let pos = getPos ix !sut in
		                     let code,content = Http.delete (deleteUrl ^ id) in
		                     if code == 200 then (
		                       sut := remove_item pos !sut;
		                       true;
		                     )
		                      else 
		                        false
		                    )
		                    else
		                      false
		'''
	}}