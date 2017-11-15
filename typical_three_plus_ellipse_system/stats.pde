void statistics(ArrayList<Float> heights) {

  if (! jingle.isPlaying() ) { 
    //  background(0);
    stroke(250);
    strokeWeight(3);
    Float avg = 0.0;
    for (int i = 0; i < heights.size(); i++) {
      avg += heights.get(i);
    }
    avg /= heights.size();
    print("heights.size() = ", heights.size(), "\n");
    println("avg = ", avg);
     println(heights);
    ArrayList<Float> firstOrder = new ArrayList<Float>();
    ArrayList<Float> secondOrder = new ArrayList<Float>();
    for (int i = 1; i < heights.size(); i++) {
      firstOrder.add( heights.get(i) - heights.get(i-1));
    }
    for (int i = 2; i < heights.size(); i++) {
      secondOrder.add( heights.get(i) + heights.get(i-2) - 2*heights.get(i-1));
    } 
    //println(firstOrder);
    println(secondOrder);
    float xdelta = width*0.7;
    float ydelta = 250;
    for (int i = 0; i < heights.size(); i++) {
      float ele =  heights.get(i);
      line(xdelta+(i)*10-20, ydelta +ele*5, xdelta+i*10-20, ydelta);
    }
    line(xdelta, ydelta, 800, ydelta );
    stroke(25, 113, 34);
    for (int i = 0; i < firstOrder.size(); i++) {
      line(xdelta+(i)*10, ydelta*1.5+firstOrder.get(i)*3, xdelta+i*10, ydelta*1.5);
    }
    line(xdelta, ydelta*1.5, 800, ydelta*1.5);
    stroke(13, 98, 56);
    for (int i = 0; i < secondOrder.size(); i++) {
      line(xdelta+i*10, ydelta*2, xdelta+(i)*10, ydelta*2+secondOrder.get(i)*3 );
    }
    line(xdelta, ydelta*2, 800, ydelta*2);
    // noLoop();
    println("\n\n\n");
  }
} 