/+  *test, *test-ford
::
/=  light-raw  /:  /===/sys/vane/light  /!noun/
::
!:
::
=/  test-pit=vase  !>(..zuse)
=/  light-gate  (light-raw test-pit)
::
|%
++  test-init
  =^  results1  light-gate
    %-  light-call  :*
      light-gate
      now=~1111.1.1
      scry=*sley
      call-args=[duct=~[/init] ~ [%init ~nul]]
      expected-moves=~
    ==
  ::
  results1
::
++  test-duplicate-bindings
  ::
  =^  results1  light-gate
    %-  light-call  :*
      light-gate
      now=~1111.1.1
      scry=*sley
      call-args=[duct=~[/init] ~ [%init ~nul]]
      expected-moves=~
    ==
  ::  app1 binds successfully
  ::
  =^  results2  light-gate
    %-  light-call  :*
      light-gate
      now=~1111.1.2
      scry=*sley
      call-args=[duct=~[/app1] ~ [%connect [~ /] %app1]]
      expected-moves=[duct=~[/app1] %give %bound %.y [~ /]]~
    ==
  ::  app2 tries to bind to the same path and fails
  ::
  =^  results3  light-gate
    %-  light-call  :*
      light-gate
      now=~1111.1.3
      scry=*sley
      call-args=[duct=~[/app2] ~ [%connect [~ /] %app2]]
      expected-moves=[duct=~[/app2] %give %bound %.n [~ /]]~
    ==
  ::
  ;:  weld
    results1
    results2
    results3
  ==
::
++  test-remove-binding
  ::
  =^  results1  light-gate
    %-  light-call  :*
      light-gate
      now=~1111.1.1
      scry=*sley
      call-args=[duct=~[/init] ~ [%init ~nul]]
      expected-moves=~
    ==
  ::  app1 binds successfully
  ::
  =^  results2  light-gate
    %-  light-call  :*
      light-gate
      now=~1111.1.2
      scry=*sley
      call-args=[duct=~[/app1] ~ [%connect [~ /] %app1]]
      expected-moves=[duct=~[/app1] %give %bound %.y [~ /]]~
    ==
  ::  app1 unbinds
  ::
  =^  results3  light-gate
    %-  light-call  :*
      light-gate
      now=~1111.1.3
      scry=*sley
      call-args=[duct=~[/app1] ~ [%disconnect [~ /]]]
      expected-moves=~
    ==
  ::  app2 binds successfully
  ::
  =^  results4  light-gate
    %-  light-call  :*
      light-gate
      now=~1111.1.4
      scry=*sley
      call-args=[duct=~[/app2] ~ [%connect [~ /] %app2]]
      expected-moves=[duct=~[/app2] %give %bound %.y [~ /]]~
    ==
  ::
  ;:  weld
    results1
    results2
    results3
    results4
  ==
::
++  test-cant-remove-other-ducts-binding
  ::
  =^  results1  light-gate
    %-  light-call  :*
      light-gate
      now=~1111.1.1
      scry=*sley
      call-args=[duct=~[/init] ~ [%init ~nul]]
      expected-moves=~
    ==
  ::  app1 binds successfully
  ::
  =^  results2  light-gate
    %-  light-call  :*
      light-gate
      now=~1111.1.2
      scry=*sley
      call-args=[duct=~[/app1] ~ [%connect [~ /] %app1]]
      expected-moves=[duct=~[/app1] %give %bound %.y [~ /]]~
    ==
  ::  app2 tries to steal the binding by disconnecting the path
  ::
  =^  results3  light-gate
    %-  light-call  :*
      light-gate
      now=~1111.1.3
      scry=*sley
      call-args=[duct=~[/app2] ~ [%disconnect [~ /]]]
      expected-moves=~
    ==
  ::  app2 doesn't bind successfully because it couldn't remove app1's binding
  ::
  =^  results4  light-gate
    %-  light-call  :*
      light-gate
      now=~1111.1.4
      scry=*sley
      call-args=[duct=~[/app2] ~ [%connect [~ /] %app2]]
      expected-moves=[duct=~[/app2] %give %bound %.n [~ /]]~
    ==
  ::
  ;:  weld
    results1
    results2
    results3
    results4
  ==
::  tests that when we have no match, that we fall back to the built-in 404
::
++  test-builtin-four-oh-four
  ::
  =^  results1  light-gate
    %-  light-call  :*
      light-gate
      now=~1111.1.1
      scry=*sley
      call-args=[duct=~[/init] ~ [%init ~nul]]
      expected-moves=~
    ==
  ::  when there's no configuration and nothing matches, expect 404
  ::
  =^  results2  light-gate
    %-  light-call  :*
      light-gate
      now=~1111.1.1
      scry=*sley
      ^=  call-args
        :*  duct=~[/http-blah]  ~
            %inbound-request
            %.n
            [%ipv4 .192.168.1.1]
            [%'GET' '/' ~ ~]
        ==
      ^=  expectec-moves
        ^-  (list move:light-gate)
        :~  :*  duct=~[/http-blah]
                %give
                %http-response
                %start
                404
                :~  ['content-type' 'text/html']
                    ['content-length' '153']
                ==
                [~ (file-not-found-page:light-gate '/')]
                complete=%.y
        ==  ==
    ==
  ::
  ;:  weld
    results1
    results2
  ==
::
++  test-basic-app-request
  ::
  =^  results1  light-gate
    %-  light-call  :*
      light-gate
      now=~1111.1.1
      scry=*sley
      call-args=[duct=~[/init] ~ [%init ~nul]]
      expected-moves=~
    ==
  ::  app1 binds successfully
  ::
  =^  results2  light-gate
    %-  light-call  :*
      light-gate
      now=~1111.1.2
      scry=*sley
      call-args=[duct=~[/app1] ~ [%connect [~ /] %app1]]
      expected-moves=[duct=~[/app1] %give %bound %.y [~ /]]~
    ==
  ::  outside requests a path that app1 has bound to
  ::
  =^  results3  light-gate
    %-  light-call-with-comparator  :*
      light-gate
      now=~1111.1.3
      scry=*sley
      ^=  call-args
        :*  duct=~[/http-blah]  ~
            %inbound-request
            %.n
            [%ipv4 .192.168.1.1]
            [%'GET' '/' ~ ~]
        ==
      ^=  comparator
        |=  moves=(list move:light-gate)
        ^-  tang
        ::
        ?.  ?=([* ~] moves)
          [%leaf "wrong number of moves: {<(lent moves)>}"]~
        ::
        ::
        =/  move=move:light-gate                              i.moves
        =/  =duct                                             duct.move
        =/  card=(wind note:light-gate gift:able:light-gate)  card.move
        ::
        %+  weld
          (expect-eq !>(~[/http-blah]) !>(duct))
        ::
        %+  expect-gall-deal
          :+  /run-app/app1  [~nul ~nul]
              ^-  cush:gall
              :*  %app1  %poke  %handle-http-request
                  !>([%.n %.n [%ipv4 .192.168.1.1] [%'GET' '/' ~ ~]])
              ==
          card
    ==
  ::  theoretical outside response
  ::
  =^  results4  light-gate
    %-  light-take  :*
      light-gate
      now=~1111.1.4
      scry=*sley
      ^=  take-args
        :*  wire=/run-app/app1  duct=~[/http-blah]
            ^-  (hypo sign:light-gate)
            :-  *type
            :^  %g  %unto  %http-response
            ^-  raw-http-response:light-gate
            [%start 200 ['content-type' 'text/html']~ [~ (as-octs:mimes:html 'Hiya!')] %.y]
         ==
      ^=  expected-move
        :~  :*  duct=~[/http-blah]  %give  %http-response
                [%start 200 ['content-type' 'text/html']~ `[5 'Hiya!'] %.y]
    ==  ==  ==
  ::
  ;:  weld
    results1
    results2
    results3
    results4
  ==
::
++  test-multipart-app-request
  ::
  =^  results1  light-gate
    %-  light-call  :*
      light-gate
      now=~1111.1.1
      scry=*sley
      call-args=[duct=~[/init] ~ [%init ~nul]]
      expected-moves=~
    ==
  ::  app1 binds successfully
  ::
  =^  results2  light-gate
    %-  light-call  :*
      light-gate
      now=~1111.1.2
      scry=*sley
      call-args=[duct=~[/app1] ~ [%connect [~ /] %app1]]
      expected-moves=[duct=~[/app1] %give %bound %.y [~ /]]~
    ==
  ::  outside requests a path that app1 has bound to
  ::
  =^  results3  light-gate
    %-  light-call-with-comparator  :*
      light-gate
      now=~1111.1.3
      scry=*sley
      ^=  call-args
        :*  duct=~[/http-blah]  ~
            %inbound-request
            %.n
            [%ipv4 .192.168.1.1]
            [%'GET' '/' ~ ~]
        ==
      ^=  comparator
        |=  moves=(list move:light-gate)
        ^-  tang
        ::
        ?.  ?=([* ~] moves)
          [%leaf "wrong number of moves: {<(lent moves)>}"]~
        ::
        ::
        =/  move=move:light-gate                              i.moves
        =/  =duct                                             duct.move
        =/  card=(wind note:light-gate gift:able:light-gate)  card.move
        ::
        %+  weld
          (expect-eq !>(~[/http-blah]) !>(duct))
        ::
        %+  expect-gall-deal
          :+  /run-app/app1  [~nul ~nul]
              ^-  cush:gall
              :*  %app1  %poke  %handle-http-request
                  !>([%.n %.n [%ipv4 .192.168.1.1] [%'GET' '/' ~ ~]])
              ==
          card
    ==
  ::  theoretical outside response
  ::
  =^  results4  light-gate
    %-  light-take  :*
      light-gate
      now=~1111.1.4
      scry=*sley
      ^=  take-args
        :*  wire=/run-app/app1  duct=~[/http-blah]
            ^-  (hypo sign:light-gate)  :-  *type
            :^  %g  %unto  %http-response
            ^-  raw-http-response:light-gate
            [%start 200 ['content-type' 'text/html']~ [~ (as-octs:mimes:html 'Hi')] %.n]
         ==
      ^=  expected-move
        :~  :*  duct=~[/http-blah]  %give  %http-response
                [%start 200 ['content-type' 'text/html']~ `[2 'Hi'] %.n]
    ==  ==  ==
  ::  theoretical outside response
  ::
  =^  results5  light-gate
    %-  light-take  :*
      light-gate
      now=~1111.1.4
      scry=*sley
      ^=  take-args
        :*  wire=/run-app/app1  duct=~[/http-blah]
            ^-  (hypo sign:light-gate)  :-  *type
            :^  %g  %unto  %http-response
            ^-  raw-http-response:light-gate
            [%continue [~ (as-octs:mimes:html 'ya!')] %.y]
         ==
      ^=  expected-move
        :~  :*  duct=~[/http-blah]  %give  %http-response
                [%continue `[3 'ya!'] %.y]
    ==  ==  ==
  ::
  ;:  weld
    results1
    results2
    results3
    results4
    results5
  ==
::  tests an app redirecting to the login handler, which then receives a post
::  and redirects back to app
::
++  test-login-handler-full-path
  ::
  =^  results1  light-gate
    %-  light-call  :*
      light-gate
      now=~1111.1.1
      scry=*sley
      call-args=[duct=~[/init] ~ [%init ~nul]]
      expected-moves=~
    ==
  ::  app1 binds successfully
  ::
  =^  results2  light-gate
    %-  light-call  :*
      light-gate
      now=~1111.1.2
      scry=*sley
      call-args=[duct=~[/app1] ~ [%connect [~ /'~landscape'] %app1]]
      expected-moves=[duct=~[/app1] %give %bound %.y [~ /'~landscape']]~
    ==
  ::  outside requests a path that app1 has bound to
  ::
  =^  results3  light-gate
    %-  light-call-with-comparator  :*
      light-gate
      now=~1111.1.3
      scry=*sley
      ^=  call-args
        :*  duct=~[/http-blah]  ~
            %inbound-request
            %.n
            [%ipv4 .192.168.1.1]
            [%'GET' '/~landscape/inner-path' ~ ~]
        ==
      ^=  comparator
        |=  moves=(list move:light-gate)
        ^-  tang
        ::
        ?.  ?=([* ~] moves)
          [%leaf "wrong number of moves: {<(lent moves)>}"]~
        ::
        ::
        =/  move=move:light-gate                              i.moves
        =/  =duct                                             duct.move
        =/  card=(wind note:light-gate gift:able:light-gate)  card.move
        ::
        %+  weld
          (expect-eq !>(~[/http-blah]) !>(duct))
        ::
        %+  expect-gall-deal
          :+  /run-app/app1  [~nul ~nul]
              ^-  cush:gall
              :*  %app1  %poke  %handle-http-request
                  !>([%.n %.n [%ipv4 .192.168.1.1] [%'GET' '/~landscape/inner-path' ~ ~]])
              ==
          card
    ==
  ::  app then gives a redirect to Eyre
  ::
  =^  results4  light-gate
    %-  light-take  :*
      light-gate
      now=~1111.1.4
      scry=*sley
      ^=  take-args
        :*  wire=/run-app/app1  duct=~[/http-blah]
            ^-  (hypo sign:light-gate)  :-  *type
            :^  %g  %unto  %http-response
            ^-  raw-http-response:light-gate
            [%start 307 ['location' '/~/login?redirect=/~landscape/inner-path']~ ~ %.y]
         ==
      ^=  expected-move
        :~  :*  duct=~[/http-blah]  %give  %http-response
                [%start 307 ['location' '/~/login?redirect=/~landscape/inner-path']~ ~ %.y]
    ==  ==  ==
  ::  the browser then fetches the login page
  ::
  =^  results5  light-gate
    %-  light-call  :*
      light-gate
      now=~1111.1.5
      scry=*sley
      ^=  call-args
        :*  duct=~[/http-blah]  ~
            %inbound-request
            %.n
            [%ipv4 .192.168.1.1]
            [%'GET' '/~/login?redirect=/~landscape/inner-path' ~ ~]
        ==
      ^=  expected-moves
        ^-  (list move:light-gate)
        :~  :*  duct=~[/http-blah]
                %give
                %http-response
                %start
                200
                :~  ['content-type' 'text/html']
                    ['content-length' '348']
                ==
                [~ (login-page:light-gate `'/~landscape/inner-path')]
                complete=%.y
        ==  ==
    ==
  ::  a response post redirects back to the application, setting cookie
  ::
  =^  results6  light-gate
    %-  light-call  :*
      light-gate
      now=~1111.1.6
      scry=*sley
      ^=  call-args
        :*  duct=~[/http-blah]  ~
            %inbound-request
            %.n
            [%ipv4 .192.168.1.1]
            %'POST'
            '/~/login'
            ~
            :-  ~
            %-  as-octs:mimes:html
            'password=lidlut-tabwed-pillex-ridrup&redirect=/~landscape'
        ==
      ^=  expected-moves
        ^-  (list move:light-gate)
        :~  :*  duct=~[/http-blah]
                %give
                %http-response
                %start
                307
                :~  ['location' '/~landscape']
                    :-  'set-cookie'
                    'urbauth=0v3.q0p7t.mlkkq.cqtto.p0nvi.2ieea; Path=/; Max-Age=86400'
                ==
                ~
                complete=%.y
        ==  ==
    ==
  ::  going back to the original url will acknowledge the authentication cookie
  ::
  =^  results7  light-gate
    %-  light-call-with-comparator  :*
      light-gate
      now=~1111.1.6..1.0.0
      scry=*sley
      ^=  call-args
        ^-  [=duct type=* wrapped-task=(hobo task:able:light-gate)]
        :*  duct=~[/http-blah]  ~
            %inbound-request
            %.n
            [%ipv4 .192.168.1.1]
            %'GET'
            '/~landscape/inner-path'
            ['cookie' 'urbauth=0v3.q0p7t.mlkkq.cqtto.p0nvi.2ieea']~
            ~
        ==
      ^=  comparator
        |=  moves=(list move:light-gate)
        ^-  tang
        ::
        ?.  ?=([* ~] moves)
          [%leaf "wrong number of moves: {<(lent moves)>}"]~
        ::
        ::
        =/  move=move:light-gate                              i.moves
        =/  =duct                                             duct.move
        =/  card=(wind note:light-gate gift:able:light-gate)  card.move
        ::
        %+  weld
          (expect-eq !>(~[/http-blah]) !>(duct))
        ::  expect authenticated=%.y in the handle below
        ::
        %+  expect-gall-deal
          :+  /run-app/app1  [~nul ~nul]
              ^-  cush:gall
              :*  %app1  %poke  %handle-http-request
                  !>([%.y %.n [%ipv4 .192.168.1.1] ['GET' '/~landscape/inner-path' ~ ~]])
              ==
          card
    ==
  ::
  ;:  weld
    results1
    results2
    results3
    results4
    results5
    results6
  ==
::
++  test-generator
  ::
  =^  results1  light-gate
    %-  light-call  :*
      light-gate
      now=~1111.1.1
      scry=*sley
      call-args=[duct=~[/init] ~ [%init ~nul]]
      expected-moves=~
    ==
  ::  gen1 binds successfully
  ::
  =^  results2  light-gate
    %-  light-call  :*
      light-gate
      now=~1111.1.2
      scry=*sley
      call-args=[duct=~[/gen1] ~ [%serve [~ /] [%home /gen/handler/hoon ~]]]
      expected-moves=[duct=~[/gen1] %give %bound %.y [~ /]]~
    ==
  ::  outside requests a path that app1 has bound to
  ::
  =^  results3  light-gate
    %-  light-call-with-comparator  :*
      light-gate
      now=~1111.1.3
      scry=*sley
      ^=  call-args
        :*  duct=~[/http-blah]  ~
            %inbound-request
            %.n
            [%ipv4 .192.168.1.1]
            [%'GET' '/' ~ ~]
        ==
      ^=  comparator
        |=  moves=(list move:light-gate)
        ^-  tang
        ::
        ?.  ?=([* ~] moves)
          [%leaf "wrong number of moves: {<(lent moves)>}"]~
        ::
        ::
        =/  move=move:light-gate                              i.moves
        =/  =duct                                             duct.move
        =/  card=(wind note:light-gate gift:able:light-gate)  card.move
        ::
        ?.  ?=(%pass -.card)
          [%leaf "not a %pass"]~
        ?.  ?=([%f %build *] q.card)
          [%leaf "not a ford build"]~
        ::
        %+  weld
          %+  expect-eq
            !>  /run-build
            !>  p.card
        ::
        %+  expect-schematic
          :^  %cast  [~nul %home]  %mime
          :+  %call
            :+  %call
              [%core [[~nul %home] /hoon/handler/gen]]
            [%$ %noun !>([[~1111.1.3 0xdead.beef [~nul %home [%da ~1111.1.3]]] ~ ~])]
          [%$ %noun !>([%.n [%'GET' '/' ~ ~]])]
        ::
          schematic.q.card
    ==
  ::  ford response (time assumes nothing blocked)
  ::
  =^  results4  light-gate
    %-  light-take  :*
      light-gate
      now=~1111.1.3
      scry=*sley
      ^=  take-args
        :*  wire=/run-build  duct=~[/http-blah]
            ^-  (hypo sign:light-gate)
            :-  *type
            :^  %f  %made  ~1111.1.3
            ^-  made-result:ford
            :-  %complete
            ^-  build-result:ford
            :-  %success
            [%cast %mime !>([['text' 'plain' ~] (as-octs:mimes:html 'one two three')])]
         ==
      ^=  expected-move
        :~  :*  duct=~[/http-blah]  %give  %http-response
                :*  %start
                    200
                    :~  ['content-type' 'text/plain']
                        ['content-length' '13']
                    ==
                    `[13 'one two three']
                    %.y
    ==  ==  ==  ==
  ::
  ;:  weld
    results1
    results2
    results3
    results4
  ==
::
++  test-simplified-url-parser
  ;:  weld
    %+  expect-eq
      !>  `[[%site 'localhost'] [~ 8.000]]
      !>  (rush 'localhost:8000' simplified-url-parser:light-gate)
  ::
    %+  expect-eq
      !>  `[[%ip .192.168.1.1] ~]
      !>  (rush '192.168.1.1' simplified-url-parser:light-gate)
  ==
::
++  test-parse-channel-request
  ;:  weld
    %+  expect-eq
      !>  `[%ack 5]~
      !>  %-  parse-channel-request:light-gate
          (need (de-json:html '[{"action": "ack", "id": 5}]'))
  ::
    %+  expect-eq
      !>  `[%poke ~nec %app1 %app-type [%n '5']]~
      !>  %-  parse-channel-request:light-gate
          %-  need  %-  de-json:html
          '''
          [{"action": "poke",
            "ship": "nec",
            "app": "app1",
            "mark": "app-type",
            "json": 5}]
          '''
  ::
    %+  expect-eq
      !>  `[%subscribe ~sampyl-sipnym %hall /this/path]~
      !>  %-  parse-channel-request:light-gate
          %-  need  %-  de-json:html
          '''
          [{"action": "subscribe",
            "ship": "sampyl-sipnym",
            "app": "hall",
            "path": "/this/path"}]
          '''
  ::
    %+  expect-eq
      !>  `[%unsubscribe ~marlyt %thing /other]~
      !>  %-  parse-channel-request:light-gate
          %-  need  %-  de-json:html
          '''
          [{"action": "unsubscribe",
            "ship": "marlyt",
            "app": "thing",
            "path": "/other"}]
          '''
  ::
    ::  after lunch, check error conditions and multipart requests.
      %+  expect-eq
        !>  ~
        !>  %-  parse-channel-request:light-gate
            %-  need  %-  de-json:html
            '[{"noaction": "noaction"}]'
  ::
      %+  expect-eq
        !>  ~
        !>  %-  parse-channel-request:light-gate
            %-  need  %-  de-json:html
            '[{"action": "bad-action"}]'
  ::
      %+  expect-eq
        !>  ~
        !>  %-  parse-channel-request:light-gate
            %-  need  %-  de-json:html
            '[{"action": "ack", "id": 5}, {"action": "bad-action"}]'
  ::
      %+  expect-eq
        !>  :-  ~
            :~  [%ack 9]
                [%poke ~bud %wut %wut-type [%a [%n '2'] [%n '1'] ~]]
            ==
        !>  %-  parse-channel-request:light-gate
            %-  need  %-  de-json:html
            '''
            [{"action": "ack", "id": 9},
             {"action": "poke",
              "ship": "bud",
              "app": "wut",
              "mark": "wut-type",
              "json": [2, 1]}]
            '''
  ==
::
++  light-call
  |=  $:  light-gate=_light-gate
          now=@da
          scry=sley
          call-args=[=duct type=* wrapped-task=(hobo task:able:light-gate)]
          expected-moves=(list move:light-gate)
      ==
  ^-  [tang _light-gate]
  ::
  =/  light-core  (light-gate now=now eny=0xdead.beef scry=scry)
  ::
  =^  moves  light-gate  (call:light-core call-args)
  ::
  =/  output=tang
    %+  expect-eq
      !>  expected-moves
      !>  moves
  ::
  [output light-gate]
::
++  light-call-with-comparator
  |=  $:  light-gate=_light-gate
          now=@da
          scry=sley
          call-args=[=duct type=* wrapped-task=(hobo task:able:light-gate)]
          move-comparator=$-((list move:light-gate) tang)
      ==
  ^-  [tang _light-gate]
  ::
  =/  light-core  (light-gate now=now eny=0xdead.beef scry=scry)
  ::
  =^  moves  light-gate  (call:light-core call-args)
  ::
  =/  output=tang  (move-comparator moves)
  ::
  [output light-gate]
::
++  light-take
  |=  $:  light-gate=_light-gate
          now=@da
          scry=sley
          take-args=[=wire =duct wrapped-task=(hypo sign:light-gate)]
          expected-moves=(list move:light-gate)
      ==
  ^-  [tang _light-gate]
  ::
  =/  light-core  (light-gate now=now eny=0xdead.beef scry=scry)
  ::
  =^  moves  light-gate  (take:light-core take-args)
  ::
  =/  output=tang
    %+  expect-eq
      !>  expected-moves
      !>  moves
  ::
  [output light-gate]
::
++  light-take-with-comparator
  |=  $:  light-gate=_light-gate
          now=@da
          scry=sley
          take-args=[=wire =duct wrapped-task=(hypo sign:light-gate)]
          move-comparator=$-((list move:light-gate) tang)
      ==
  ^-  [tang _light-gate]
  ::
  =/  light-core  (light-gate now=now eny=0xdead.beef scry=scry)
  ::
  =^  moves  light-gate  (take:light-core take-args)
  ::
  =/  output=tang  (move-comparator moves)
  ::
  [output light-gate]
::
++  expect-gall-deal
  |=  $:  expected=[wire=path id=sock data=cush:gall]
          actual=(wind note:light-gate gift:able:light-gate)
      ==
  ^-  tang
  ::
  ?.  ?=(%pass -.actual)
    [%leaf "bad move, not a %pass: {<actual>}"]~
  ::
  %+  weld
    (expect-eq !>(wire.expected) !>(p.actual))
  ::
  =/  note=note:light-gate  q.actual
  ?.  ?=([%g %deal *] note)
    [%leaf "bad move, not a %deal: {<actual>}"]~
  ::
  %+  weld
    (expect-eq !>(id.expected) !>(id.note))
  ::
  %+  weld
    (expect-eq !>(p.data.expected) !>(p.data.note))
  ::  todo: handle other deals
  ::
  ?.  ?=([%poke *] q.data.note)
    [%leaf "todo: can only handle %poke right now"]~
  ?.  ?=([%poke *] q.data.expected)
    [%leaf "todo: can only handle %poke right now"]~
  ::
  %+  weld
    (expect-eq !>(p.p.q.data.expected) !>(p.p.q.data.note))
  ::  compare the payload vases
  ::
  (expect-eq q.p.q.data.expected q.p.q.data.note)
--
