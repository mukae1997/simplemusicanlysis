# Minim初体验：利用幅度（amplitude）变化进行简单的音乐分析

首先从示例程序出发，稍微看了一下之后选择了从Analysis-SoundSpectrum这个示例开始探索，目标是能拿到和音乐内容相关的数据，从而实现简单的分析，最简单的就是某种元素的“有无”，简单来说，以这次实验用到的钢琴曲为例，就是钢琴响一下，就应该探测到这一下是什么时候开始和结束的，然后就可以可视化出来了！Let's go.



首先看会用到的类：

```java
Minim minim;   // 必须初始化的对象
AudioPlayer jingle; // 控制音乐播放
FFT fftLin;
FFT fftLog;
```

`FFT`类是分析用到的关键对象，音频是时域上的数据流，经过FFT之后就能变换到频域。声音是不同频率信号的叠加，那么如果对于一种声音（钢琴声，吉他声etc）我们能够知道它相应的频率（带），那么分析应该就会很简单了。（当然并没有那么简单，因为对我们而言的一种声音实际上也混进了很多的频率）



```java

  fftLin = new FFT( jingle.bufferSize(), jingle.sampleRate() );
  fftLin.linAverages( 30 );
  fftLog = new FFT( jingle.bufferSize(), jingle.sampleRate() );
  fftLog.logAverages( 22, 3 );
  
```

组成音频的信号的频率的范围取值从1到几万(e.g.  44100 Hz)不等（这个说法不严谨但暂这么认为），但要实时地分析几万个信号不太高效，而Minim提供了两种方法将信号按频率划分成不同的`band`以方便后续的分析，分别是：**linAverages**和**logAverages**，顾名思义，线性的和对数的。

线性的就是等距划分，所以每一组（就是每一个`average band`）的宽度会想等，对数划分的则是非等距的。

对数划分是按`octave`划分的，官网给出的解释如下：

> One frequency is an octave above another when it's frequency is twice that of the lower frequency.So, 120 Hz is an octave above 60 Hz, 240 Hz is an octave above 120 Hz, and so on.  .. 

并也说是与人类平时辨别的音调有关（*they map more directly to how humans perceive sound.*）



数学原理暂搞不清楚，但怀着调用API应该也能做出一点东西的心情，继续探索。

调用`FFT`对象的`forward`函数，得到频域结果以后就可以开始分析了。代码写的很清楚，它提供的可视化就是一个循环取出每一个band的amplitude，然后将其映射到矩形的高度上。

![](sndspec.JPG)
![这里写图片描述](http://img.blog.csdn.net/20171115114922901?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvTXVrYWUxOTk3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)


这个示例程序表示出来的基本就这么多了。

那么如何利用它进行音乐分析呢？

首先从这个频率变化的图，可以明显看出有一些带的高度大，变化剧烈，那么，可以认为它代表了当前音乐的大致变化，暂时称它为`typical band`，因为矩形的高度和该信号的幅度（amplitude）有关，也就是信号的强度，那么不妨假定，幅度大的、变化剧烈的频段，反映的正是人耳识别到的最明显的声音。



那么接下来就是数学问题了： **如何在众多频段中识别出变化最剧烈的？**

在这里，我借用了图像处理的知识，在识别图像边缘时，会用到二阶微分，发生零交叉时，正是信号变化剧烈的地方。后来我又粗略阅读了语音分析的书，发现也有这个概念，但使用的是时域上的波形，检测信号在一段时间内的**过零数**作为一种分析的手段。



首先从短的、变化简单的音乐开始，这里用了约5秒的钢琴曲，弹了7下，对第一个频段（对于这段音乐而言它是变化最明显的）的采样图如下（注意，这里的采样只是我个人粗暴的手动采样，只是为了get it started） ：

![](7.JPG)
![这里写图片描述](http://img.blog.csdn.net/20171115114955571?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvTXVrYWUxOTk3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
从上到下，分别是原幅度、一阶差分、二阶差分。可以数一数第三图的函数值符号变化的次数，是不是有点接近7次呢？



按着这个思路做了一些工夫，虽然idea很简单，但是实现起来还是有蛮多烦人的细节的，比如说二阶差分值也许会在一段时间内多次穿越零，但它的绝对值也许很小，那么要将阈值设定在何处，才能正确识别到反映了声音变化的数值呢？(这个问题我基本是参照平均值进行硬调_(:зゝ∠)_。。。)

另一个问题是如何选择typical band，由于音乐的组成有可能变化，那么是否要隔一段时间改变一次typical band呢？定时改变也许不是一个好主意，因为这样一来可视化后的画面可能变得断断续续，显得和音乐没有相关性，也许根据频段本身的变化来决定更好。



*end*
 
