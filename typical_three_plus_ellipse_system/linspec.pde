void draw()
{ 
  
    int t = frameCount;
    // count from where the music really begins.
    //println("jingle.position()    ",jingle.position());
    if (jingle.position() < 100) t = 0;
  for (int i = 0; i<bandsChosen; i++) {
    //println("udate");
    systems[i].update();
  }
  background(240); 

  textFont(font);
  textSize( 18 );

  float centerFrequency = 0;

  // perform a forward FFT on the samples in jingle's mix buffer
  // note that if jingle were a MONO file, this would be the same as using jingle.left or jingle.right
  fftLin.forward( jingle.mix );
  fftLog.forward( jingle.mix );


  int s =3; 
  { 
    int w = int( width/fftLin.avgSize() );
    int realFreqSetSize = BAND_COUNT/2;
    float   avgLinFreq = 0;
    for (int i = 0; i < realFreqSetSize; i++) { 

      if ( mouseX >= i*w && mouseX < i*w + w )
      {
        centerFrequency = fftLin.getAverageCenterFrequency(i); 
        fill(0, 128);
        text("Linear Average Center Frequency: " + centerFrequency, 5, height23 - 25); 
        fill(0, 0, 0);
      } else {
        fill(0);
      }
      rect(i*w, height23, i*w + w, height23 - fftLin.getAvg(i)*spectrumScale);

      //if (t%3 == 0 && typicalBand < 0)
      //if (frameCount%20 == 0&& fftLin.getAvg(i)>1) println("i = ", i, " fftLin.getAvg(i)  ", fftLin.getAvg(i));  
      avgLinFreq += fftLin.getAvg(i);
    }
    avgLinFreq /= realFreqSetSize;
    if (t % 60 == 0 && t != 0 ) {
      println("avgLinFreq = ", avgLinFreq,"  at time = ", t/60," sec");
      println("scale it ---> ", (int)(avgLinFreq*10));
    }
    for (int i = 0; i < realFreqSetSize; i++) {

      if (frameCount%4 == 0 && typicalBand < 0 && fftLin.getAvg(i) > max(avgLinFreq, 1)) {
        typiBandTable[ initSampleCount+typicalBand][i] = fftLin.getAvg(i);
        //println("fftLin.getAvg(i)  ",fftLin.getAvg(i));
        isSam = true;
      }
    }
  }

  if (typicalBand<0&&isSam) {
    typicalBand++;
    isSam=false;
  }
  if (typicalBand == 0 && prt) {
    Map<Float, Integer> sums = new HashMap<Float, Integer>();
    //float maxoscill = 1000; // should be minus.
    println("typiBandTable"); 
    for (int i = 0; i < BAND_COUNT/2; i++) {
      float fi, fi1, fi2; 
      fi = typiBandTable[3][i];
      fi1 = typiBandTable[2][i];
      fi2 = typiBandTable[1][i];
      float fi3 = typiBandTable[0][i];
      println(i, fi, fi1, fi2, fi3);
      if (fi*fi1*fi2*fi3 != 0) {
        float sum1 = fi + fi2 - 2*fi1;
        float sum2 = fi1 + fi3 - 2*fi2;
        //println(fi, fi1, fi2, fi3);
        //println("i = ", i, "sum1 ", sum1, "sum2  ", sum2 );
        sums.put(sum1 * sum2, i ); 
        //if (sum1 * sum2 < maxoscill) {
        //  maxoscill = sum1 * sum2;
        //  typicalBand = i;
        //}
      } else {
         sums.put(0.0, i ); 
      }
    }
      //println(sums);

    SortedSet<Float> keysset = new TreeSet<Float>(sums.keySet()); 
    List<Float>keys = new ArrayList<Float>(keysset);
    int endToPick = 0;
    //println("keys = ", keys);
    for (int i = 0; i < min(bandsChosen, sums.size()); i++) {
      Integer bandNumber = sums.get(keys.get(endToPick));
      endToPick++;
      typiBandsNumber.add(bandNumber);
    }
    prt = false;
    typiBandsNumber.set(0, 0);//debug
    println("typicalBand = ", typiBandsNumber);
  }

  /*
      after choosing the typical band,
   program enter the area below
   and draw the circle. 
   */
  s = 5 ;
  //println("typicalBand ", typicalBand);
  if (typicalBand >= 0 ) {
    for (int i = 0; i < min(bandsChosen, typiBandsNumber.size()); i++) {
      if (frameCount % s == 0 
        && fftLin.getAvg(typiBandsNumber.get(i)) >= 2) { // && h > threshold 
        Float h = fftLin.getAvg(typiBandsNumber.get(i));
        heights.get(i).add(h);
        // println(" heights.get(i) ",  heights.get(i));
        // println("heights.size()", heights.size());
        if (heights.get(i).size() >= 4) {
          float fi, fi1, fi2; 
          fi = heights.get(i).get(heights.get(i).size()-1);
          fi1 = heights.get(i).get(heights.get(i).size()-2);
          fi2 = heights.get(i).get(heights.get(i).size()-3);
          float fi3 = heights.get(i).get(heights.get(i).size()-4);
          float sum1 = fi + fi2 - 2*fi1;
          float sum2 = fi1 + fi3 - 2*fi2; 
          //if (i == 0)   println("[", i, "]", sum1, " *  ", sum2, sum1 * sum2 ); 
          float sensitivity = -10 ;
          //if (i == 0) println("sum1 * sum2 ", sum1 * sum2);
          avg[i] += sum1 * sum2;
          if (sum1 * sum2 < sensitivity 
            //&&  sum2 < 0  
            // && abs(sum2) > 4
            ) { // control sensitivity
            systems[i].add();
          }
        }
      }
    }
  }

  float cx = width*0.8;
  float cy = height/4;
  for (int i = 0; i < bandsChosen; i++) { 
    systems[i].show();
  }
  if (! jingle.isPlaying() ) {
    statistics(heights.get(0));
    println(" >   avg secondOrder products of[0]", avg[0]/heights.get(0).size());
    statistics(heights.get(1));
    println(" >   avg secondOrder products of[1]", avg[1]/heights.get(1).size());
    statistics(heights.get(2));
    println(" >   avg secondOrder products of[2]", avg[2]/heights.get(2).size());
  }
}

void mousePressed() {
  int w = int( width/fftLin.avgSize() ); 

  for (int i = 0; i < 20; i++) {// fftLog.avgSize()
    float centerFrequency = fftLin.getAverageCenterFrequency(i);   
    if ( mouseX >= i*w && mouseX < i*w + w )
    {
      fill(255, 128);

      typiBandsNumber.set((loopbn++)%bandsChosen, i);
      text("typicalBand  "+i, 100, height*0.75);
      fill(0, 0, 0);
    }
  }
  println("typicalBand = ", typiBandsNumber);
}