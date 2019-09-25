//---------------------------APP---------------------------

(
~isOn = false;
~effectOn = false;
~pitchOn = false;
~currentProgram = "";
~currentPath = "/home/cesare/Documenti/università/EAEM/Andrea Valle/grillo_parlante";
~view.value;
~controller.value;

)

//---------------------------CONTROLLER---------------------------
(
~controller = {

    //-
    b[0][0].action_({arg me;
        ~isOn = false;
        ~setText.value("");
    });

    //Vai
    b[0][1].action_({arg me;
        if(~isOn){
            switch (~currentProgram)
            {"ripeti"} {~ripeti.value}
            {"indovina"}{}
            {"alfabeto"}{}

       }
    });

    //Rit
    b[0][2].action_({arg me;
        if(~isOn){
            ~setText.value(me.states[0][0]);
       }
    });

    //Rep
    b[0][3].action_({arg me;
        if(~isOn){
            ~setText.value(me.states[0][0]);
       }
    });

    //SOS
    b[0][4].action_({arg me;
        if(~isOn){
            ~setText.value(me.states[0][0]);
       }
    });

    //?
    b[0][5].action_({arg me;
         if(~isOn){
            ~setText.value(me.states[0][0]);
            ~currentProgram = "indovina";
       }
    });

    //Cod
    b[0][6].action_({arg me;
         if(~isOn){
            ~setText.value("SCRIVI A");
            ~currentProgram = "codice";
       }
    });

    //Alf
    b[0][7].action_({arg me;
         if(~isOn){
            ~setText.value("");
            ~currentProgram = "alfabeto";
            ~alfabeto.value();
       }
    });

    //Rip
    b[0][8].action_({arg me;
         if(~isOn){
            ~setText.value("RIPETI");
            ~currentProgram = "ripeti";
       }
    });

    //+
    b[0][9].action_({arg me;
        var sound = ~currentPath++"/sound/system/start-"++
        ["1.wav", "2.wav", "3.wav"].choose;
        ~isOn = true;
        ~setText.value("SCRIVI A");
        ~playSound.value(sound);
    });

    //Canc
    b[3][8].action_({arg me;
         if(~isOn){
            ~setText.value(me.states[0][0]);
       }
    });

    //Con
    b[3][9].action_({arg me;
        if(~isOn){
            ~setText.value(me.states[0][0]);
       }
    });

    //'
    b[3][6].action_({arg me;
        var sound;
        if(~isOn)
        {
            if((~currentProgram == "") || (~currentProgram == "ripeti"))
            {
                sound = ~currentPath++"/sound/system/start-"++
                ["1.wav", "2.wav", "3.wav"].choose;
            }
            {
                ~write.value(me.states[0][0]);
                sound = ~currentPath++"/sound/system/"++
                me.states[0][0]++".wav"
            };
            ~playSound.value(sound)
        };
    });

    //Glitch button
    e.action_({arg me;
        if(me.value == 0)
        {~effectOn = false}
        {~effectOn = true}

    });

    //Glitch slider
    k.action_({arg me;
        ~noiseLevel = me.value.linlin(0.0, 1.0, 0.5, 3.0);
    });

    //Pitch button
    p.action_({arg me;
        if(me.value == 0)
        {~pitchOn = false}
        {~pitchOn = true}
    });

    //Pitch slider
    l.action_({arg me;
        ~pitchLevel = me.value.linlin(0.0, 1.0, 0.3, 3);
    });

    //letters
    26.do({arg i;
        var col = i%10;
        var row = trunc(i/10)+1;
        var sound;
        b[row][col].action_({arg me;
            if(~isOn)
            {
                if((~currentProgram == "") || (~currentProgram == "ripeti"))
                {
                    sound = ~currentPath++"/sound/system/start-"++
                    ["1.wav", "2.wav", "3.wav"].choose;
                }
                {
                    ~write.value(me.states[0][0]);
                    sound = ~currentPath++"/sound/letters/"++
                    me.states[0][0]++".wav"
                };
                ~playSound.value(sound)
            };
        });
    });
};

)
//---------------------------VIEW---------------------------
(
~view = {
    var winH = 500;
    var winW = 800;
    var buttonH = 65;
    var buttonW = 65;
    var textH = 65;
    var textW = 410;
    var leftSpaceB = 50;
    var leftSpaceT = 345;
    var topSpaceT = 70;
    var lettere = ['-', "Via", "Ritorna", "Replica", "SOS", "?", "Codice",
        "Alfabeto", "Ripeti", "+", "A", "B", "C", "D", "E", "F", "G",
        "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R",
        "S", "T", "U", "V", "W", "X", "Y", "Z", "'", "#", "Cancella", "Controlla"];

    w =  Window.new("Grillo Parlante", Rect.new(100, 100, winW, winH));

    //Create monitor
    t = TextView(w, Rect(leftSpaceT,topSpaceT, textW, textH ))
    .editable_(false)
    .font_(Font("Latin Modern Mono Caps", 40))
    .stringColor_(Color.green);
    t.background = Color.black;
    t.hasVerticalScroller = false;

    //create keyboard a matrix
    b = Array.fill(4, {arg i;
        Array.fill(10, {arg j;
            Button(w, Rect(leftSpaceB+(buttonW*j*1.1),
                200+(buttonH*i*1.1), buttonW, buttonH))
            .states_([[lettere[(i*10)+j], Color.black]])
        });
    });

    //Glitch button
    e = Button(w, Rect(leftSpaceB, topSpaceT, 40, 40))
    .states_([
        ["Glitch", Color.white, Color.red],
        ["Glitch", Color.white, Color.green]
    ]);

    //Pitch button
    p = Button(w, Rect(leftSpaceB, topSpaceT+50, 40, 40))
     .states_([
        ["Pitch", Color.white, Color.red],
        ["Pitch", Color.white, Color.green]
    ]);

    //Glitch slider
    k = Slider(w,Rect(leftSpaceB+50, topSpaceT+5, 190, 30));

    //Pitch slider
    l = Slider(w,Rect(leftSpaceB+50, topSpaceT+55, 190, 30));
    w.front ;
};

)

//---------------------------MODEL---------------------------
(

//function for display the given text
~setText = {arg text;
    t.string = "";
    t.setString(text, 0, inf)
    .stringColor_(Color.green)
};

//function for write a letter
~write = {arg letter;
    var toDisplay = t.string++letter;
    t.string = "";
    t.setString(toDisplay, 0, inf)
    .stringColor_(Color.green);
};

/*
SynthDef(\playBufEffect, {arg bufnum, par1 = 0;
    var rate = LFNoise2.kr(par1)
    var buf = BufRd.ar(1, bufnum, BufRateScale.kr(bufnum)*rate,);
    Out.ar(0, Pan2.ar(buf, 0))
}).add;
*/

//Play the buffer content at the specified rate (default 1)

SynthDef(\playBuf,{ arg bufnum, rate = 1;
    Out.ar(0, Pan2.ar(PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum)*rate,
        doneAction:2), 0))
}).add;

// Play the buffer at the givin random phase modulable by @noise
// the the signal is multiplied by a linear envelope just for terminate it
SynthDef(\playBufEffect, {arg bufnum, noise = 1;
   var buf = BufRd.ar(1, bufnum,
        LFNoise1.ar(noise, 2)*
        EnvGen.ar(
            Env.linen(0,
                BufDur.kr(bufnum), 0),doneAction:2)*
        BufFrames.ir(bufnum));
    Out.ar(0, Pan2.ar(buf, 0))
}).add;

//function that play the sound at the given path considering any effects
~playSound = { arg soundPath;
    if(~effectOn)
    {
        if(~pitchOn)
        {
            Synth(\playBufEffect, [
                \bufnum, Buffer.read(s, soundPath, bufnum:0),
                \noise, ~noiseLevel])
        }
        {
            Synth(\playBufEffect, [
                \bufnum, Buffer.read(s, soundPath, bufnum:0),
                \noise, ~noiseLevel])
        }
    }
    {
        if(~pitchOn)
        {
            Synth(\playBuf, [
            \bufnum, Buffer.read(s, soundPath, bufnum:0),
            \rate, ~pitchLevel
            ])
        }
        {Synth(\playBuf, [\bufnum, Buffer.read(s, soundPath, bufnum:0)])}


    };

};

//partial implementation of the original Grillo parlante's Ripeti program
~ripeti = {
    var path = ~currentPath++"/sound/word";
    var myPath = PathName.new(path);
    var pathRipeti = ~currentPath++"/sound/system/ripeti v2.wav";
    var words = Array.fill(10,{
        myPath.entries.choose.fullPath;
    });
    var progRipeti = Routine({
        10.do({arg i;
            //~setText.value(PathName(soundPath).fileNameWithoutExtension);
            ~playSound.value(~currentPath++"/sound/system/ripeti v2.wav");
            1.wait;
            ~playSound.value(words.at(i));
            3.wait;
        })
    }).play;


};

//implementation of the original Grillo parlante's Alfabeto program
~alfabeto = {
    var path = ~currentPath++"/sound/letters";
    var myPath = PathName.new(path);
    var letter = myPath.entries.choose.fullPath;
    var let = PathName.new(letter).fileNameWithoutExtension;
    ~setText.value(let);
    ~playSound.value(letter);
};

)