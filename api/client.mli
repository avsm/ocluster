open Capnp_rpc_lwt

module Process : sig
  module Out : sig
    type t = Raw.Client.ProcessOut.t Capability.t

    val stdout :
      chunk:string -> t -> (unit, [> `Capnp of Capnp_rpc.Error.t ]) Lwt_result.t

    val stderr :
      chunk:string -> t -> (unit, [> `Capnp of Capnp_rpc.Error.t ]) Lwt_result.t

    val complete :
      exit_code:int32 ->
      t ->
      (unit, [> `Capnp of Capnp_rpc.Error.t ]) Lwt_result.t
  end

  module In : sig
    type t = Raw.Client.ProcessIn.t Capability.t

    val stdin :
      chunk:string -> t -> (unit, [> `Capnp of Capnp_rpc.Error.t ]) Lwt_result.t

    val cancel : t -> (unit, [> `Capnp of Capnp_rpc.Error.t ]) Lwt_result.t
  end
end

module Agent : sig
  type t = Raw.Client.Agent.t Capability.t

  type command = string * string array

  val exec :
    cmd:command -> t -> (int32, [> `Capnp of Capnp_rpc.Error.t ]) Lwt_result.t

  val spawn : command -> Process.Out.t -> t -> Process.In.t
end

module Cluster : sig
  type t = Raw.Client.Cluster.t Capability.t

  val register : hostname:string -> callback:Agent.t -> t -> unit Lwt.t

  val find : hostname:string -> t -> Agent.t
end
