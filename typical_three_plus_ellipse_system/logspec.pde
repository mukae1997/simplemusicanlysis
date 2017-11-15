

//void draw()
//{ 
//  for (int i = 0; i<bandsChosen; i++) {
//    //println("udate");
//    systems[i].update();
//  }
//  background(100);

//  textFont(font);
//  textSize( 18 );

//  float centerFrequency = 0;

//  // perform a forward FFT on the samples in jingle's mix buffer
//  // note that if jingle were a MONO file, this would be the same as using jingle.left or jingle.right
//  fftLin.forward( jingle.mix );
//  fftLog.forward( jingle.mix );


//  int s = 2;
//  float energythreshold = 1; 
//  { 
//    for (int i = 0; i < BAND_COUNT; i++) {// fftLog.avgSize()
//      centerFrequency    = fftLog.getAverageCenterFrequency(i); 
//      float averageWidth = fftLog.getAverageBandWidth(i);   
 
//      float lowFreq  = centerFrequency - averageWidth/2;
//      float highFreq = centerFrequency + averageWidth/2;
 
//      // the average.
//      int xl = (int)fftLog.freqToIndex(lowFreq)*10;
//      int xr = (int)fftLog.freqToIndex(highFreq)*10;
 
//      if ( mouseX >= xl && mouseX < xr )
//      {
//        fill(255, 128);
//        text("Logarithmic Average Center Frequency: " + centerFrequency, 5, height - 25);
//        fill(255, 0, 0);
//      } else
//      {
//        fill(#6092F2);
//      }
//      // draw a rectangle for each average, multiply the value by spectrumScale so we can see it better
//      rect( xl, height, xr, height - fftLog.getAvg(i)*spectrumScale );

//      //println("t%s == 0 ", t%s == 0);
//      // todo 
//      //if (t%3 == 0 && typicalBand < 0)println("fftLin.getAvg(i)  ",fftLin.getAvg(i));  
//      if (frameCount%s == 0 && typicalBand < 0
//        && fftLog.getAvg(i) > energythreshold/2) {
//        /*
          
//         get sample from the starting seconds,
//         to decide the starting typical bands.
         
//         typiBandTable is a 4*BAND_COUNT matrix,
//         records the ampitudes of the corrsponding freq.
         
//         */
//        typiBandTable[ initSampleCount+typicalBand][i] = fftLog.getAvg(i);
//        //println("fftLin.getAvg(i)  ",fftLin.getAvg(i));
//        isSam = true;
//      }
//    }
//  }

//  if (typicalBand<0 && isSam) {
//    /* DECIDING TYPICAL BANDS 
//    typicalBand < 0 whenver sampling is going on. 
//     isSam is a flag.
//     */
//    typicalBand++;
//    isSam=false;
//  }
//  if (typicalBand == 0&&prt) {
//    /*  DECIDING TYPICAL BANDS
//    typicalBand reaches 0 when sampling is done.
//     prt: ensure sampling done only once 
//     when there's no directive to reset typical Bands.
//     */
//    Map<Float, Integer> sums = new HashMap<Float, Integer>(); 
//    for (int i = 0; i < BAND_COUNT; i++) {
//      float fi, fi1, fi2; 
//      fi = typiBandTable[3][i];
//      fi1 = typiBandTable[2][i];
//      fi2 = typiBandTable[1][i];
//      float fi3 = typiBandTable[0][i];
//      /*
      
//      smaller rows number indicates earlier samples.
//      cols ---- bands.
//      */
//      float sum1 = fi + fi2 - 2*fi1;
//      float sum2 = fi1 + fi3 - 2*fi2;
//      println(fi, fi1, fi2, fi3);
//      //println("[", i, "]", " sum1 * sum2", sum1 * sum2 ); 
//      //println("i = ", i, "sum1 ", sum1, "sum2  ", sum2 );
//      sums.put(sum1 * sum2, i); 
//      //if (sum1 * sum2 < maxoscill) {
//      //  maxoscill = sum1 * sum2;
//      //  typicalBand = i;
//      //}
//    }

//    SortedSet<Float> keysset = new TreeSet<Float>(sums.keySet()); 
//    List<Float>keys = new ArrayList<Float>(keysset);
//    /* DECIDING TYPICAL BANDS
//    sort the secondOrder products by value from big to small.
//     the ones at last are minus and have big magnitude,
//     meaning a great change in amplitude
     
//     */
//    int endToPick = 0;
//    //println("keys = ", keys);
//    for (int i = 0; i < min(bandsChosen, sums.size()); i++) {
//      Integer bandNumber = sums.get(keys.get(endToPick));
//      endToPick++;
//      typiBandsNumber.add(bandNumber);
//    }
//    prt = false;
//    println("\n\n ----------   typicalBand = ", typiBandsNumber);
//  }

//  s = 10 ;
//  //println("typicalBand ", typicalBand);
//  if (typicalBand >= 0 ) {

//    /*
//      after choosing the typical band,
//     program enter the area below
//     and draw the circle. 
//     the part of "DECIDING TYPICAL BANDS" will not be entered,
//     until there's a call to reset it .
//     */
//    for (int i = 0; i < min(bandsChosen, typiBandsNumber.size()); i++) {
//      if (frameCount % s == 0 
//        && fftLog.getAvg(typiBandsNumber.get(i)) >= energythreshold) { // && h > threshold 


//        /*
        
//         TODO : HOW TO TUNE THE THESHOLD?
         
//         */


//        Float h = fftLog.getAvg(typiBandsNumber.get(i));
//        heights.get(i).add(h);
//        // println(" heights.get(i) ",  heights.get(i));
//        // println("heights.size()", heights.size());
//        if (heights.get(i).size() >= 4) {
//          /*  prevention of array out of bounds   
          
//          heights.get(i) : save the amplitudes samples of band [i]
//          */
//          float fi, fi1, fi2; 
//          fi = heights.get(i).get(heights.get(i).size()-1);
//          fi1 = heights.get(i).get(heights.get(i).size()-2);
//          fi2 = heights.get(i).get(heights.get(i).size()-3);
//          float fi3 = heights.get(i).get(heights.get(i).size()-4);
//          float sum1 = fi + fi2 - 2*fi1;
//          float sum2 = fi1 + fi3 - 2*fi2; 
//          if (typiBandsNumber.get(i) == 17)
//           println("[", typiBandsNumber.get(i), "]", sum1, " *  ", sum2,"=", sum1 * sum2 );
//          avg[i] += sum1 * sum2;
//          float sensitivity = -30;
//          //if (i == 0) println("sum1 * sum2 ", sum1 * sum2);
//          if (sum1 * sum2 < sensitivity  ) { // control sensitivity
//            systems[i].add();
//          }
//        }
//      }
//    }
//  }


//  float cx = width*0.8;
//  float cy = height/4;
//  for (int i = 0; i < bandsChosen; i++) { 
//    systems[i].show();
//  }
//  if (! jingle.isPlaying() ) {
//    statistics(heights.get(0));
//    println(" >   avg secondOrder products of[0]", avg[0]/heights.get(0).size());
//    statistics(heights.get(1));
//    println(" >   avg secondOrder products of[1]", avg[1]/heights.get(1).size());
//    statistics(heights.get(2));
//    println(" >   avg secondOrder products of[2]", avg[2]/heights.get(2).size());
//  }
//}

//void mousePressed() {

//  for (int i = 0; i < 20; i++) {// fftLog.avgSize()
//    float centerFrequency = fftLog.getAverageCenterFrequency(i); 
//    float averageWidth = fftLog.getAverageBandWidth(i);    
//    float lowFreq  = centerFrequency - averageWidth/2;
//    float highFreq = centerFrequency + averageWidth/2;
 
//    int xl = (int)fftLog.freqToIndex(lowFreq)*10;
//    int xr = (int)fftLog.freqToIndex(highFreq)*10;

//    // if the mouse is inside of this average's rectangle 
//    if ( mouseX >= xl && mouseX < xr )
//    {
//      fill(255, 128);
//      typiBandsNumber.set((loopbn++)%bandsChosen, i);
//      text("typicalBand  "+i, 100, height*0.75);
//      fill(255, 0, 0);
//      println("typicalBand = ", typiBandsNumber);
//    }
//  }
//}