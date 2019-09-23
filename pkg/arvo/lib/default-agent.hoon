|_  [=bowl:mall =agent:mall]
++  handle-init
  `agent
::
++  handle-extract-state
  ~&  "extracting empty state for {<dap.bowl>}"
  !>(~)
::
++  handle-upgrade-state
  |=  old-state=vase
  ~&  "updating agent {<dap.bowl>} by throwing away old state"
  `agent
::
++  handle-poke
  |=  =cage
  ~&  "unexpected poke to {<dap.bowl>} with mark {<p.cage>}"
  ~|  "unexpected poke to {<dap.bowl>} with mark {<p.cage>}"
  !!
::
++  handle-subscribe
  |=  =path
  ~&  "unexpected subscription to {<dap.bowl>} on path {<path>}"
  ~|  "unexpected subscription to {<dap.bowl>} on path {<path>}"
  !!
::
++  handle-unsubscribe
  |=  path
  `agent
::
++  handle-peek
  |=  path
  ~|  "unexpected scry into {<dap.bowl>} on path {<path>}"
  !!
::
++  handle-agent-response
  |=  [=wire =gift:agent:mall]
  ?-    -.gift
      %poke-ack          `agent
      %subscription-ack  `agent
      %subscription-close
    ~|  "unexpected subscription closure to {<dap.bowl>} on wire {<wire>}"
    !!
  ::
      %subscription-update
    ~|  "unexpected subscription update to {<dap.bowl>} on wire {<wire>}"
    ~|  "with mark {<p.cage.gift>}"
    !!
  ::
      %http-response
    ~|  "unexpected http-response to {<dap.bowl>} on wire {<wire>}"
    !!
  ==
::
++  handle-arvo-response
  |=  [=wire =sign-arvo]
  ~|  "unexpected system response {<-.sign-arvo>} to {<dap.bowl>} on wire {<wire>}"
  !!
::
++  handle-error
  |=  [=term =tang]
  %-  (slog leaf+"error in {<dap.bowl>}" >term< tang)
  `agent
--
