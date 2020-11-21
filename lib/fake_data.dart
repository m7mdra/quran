const DATA = """
{
  "number": 2,
  "name": "سورة البقرة",
  "transliteration_en": "Al-Baqra",
  
  "verses": [
    {
      "number": 1,
      "text": "الٓمٓ"
    },
    {
      "number": 2,
      "text": "ذَٰلِكَ ٱلْكِتَٰبُ لَا رَيْبَ فِيهِ هُدًى لِّلْمُتَّقِينَ" },
    {
      "number": 3,
      "text": "ٱلَّذِينَ يُؤْمِنُونَ بِٱلْغَيْبِ وَيُقِيمُونَ ٱلصَّلَوٰةَ وَمِمَّا رَزَقْنَٰهُمْ يُنفِقُونَ"},
    {
      "number": 4,
      "text": "وَٱلَّذِينَ يُؤْمِنُونَ بِمَآ أُنزِلَ إِلَيْكَ وَمَآ أُنزِلَ مِن قَبْلِكَ وَبِٱلْءَاخِرَةِ هُمْ يُوقِنُونَ"
     
    },
    {
      "number": 5,
      "text": "أُو۟لَٰٓئِكَ عَلَىٰ هُدًى مِّن رَّبِّهِمْ وَأُو۟لَٰٓئِكَ هُمُ ٱلْمُفْلِحُونَ"
      },
    {
      "number": 6,
      "text": "إِنَّ ٱلَّذِينَ كَفَرُوا۟ سَوَآءٌ عَلَيْهِمْ ءَأَنذَرْتَهُمْ أَمْ لَمْ تُنذِرْهُمْ لَا يُؤْمِنُونَ"
    
    },
    {
      "number": 7,
      "text": "خَتَمَ ٱللَّهُ عَلَىٰ قُلُوبِهِمْ وَعَلَىٰ سَمْعِهِمْ وَعَلَىٰٓ أَبْصَٰرِهِمْ غِشَٰوَةٌ وَلَهُمْ عَذَابٌ عَظِيمٌ"    },
    {
      "number": 8,
      "text": "وَمِنَ ٱلنَّاسِ مَن يَقُولُ ءَامَنَّا بِٱللَّهِ وَبِٱلْيَوْمِ ٱلْءَاخِرِ وَمَا هُم بِمُؤْمِنِينَ"
    },
    {
      "number": 9,
      "text": "يُخَٰدِعُونَ ٱللَّهَ وَٱلَّذِينَ ءَامَنُوا۟ وَمَا يَخْدَعُونَ إِلَّآ أَنفُسَهُمْ وَمَا يَشْعُرُونَ"
        },
    {
      "number": 10,
      "text": "فِى قُلُوبِهِم مَّرَضٌ فَزَادَهُمُ ٱللَّهُ مَرَضًا وَلَهُمْ عَذَابٌ أَلِيمٌۢ بِمَا كَانُوا۟ يَكْذِبُونَ"
       },
    {
      "number": 11,
      "text": "وَإِذَا قِيلَ لَهُمْ لَا تُفْسِدُوا۟ فِى ٱلْأَرْضِ قَالُوٓا۟ إِنَّمَا نَحْنُ مُصْلِحُونَ"
    },
    {
      "number": 12,
      "text": "أَلَآ إِنَّهُمْ هُمُ ٱلْمُفْسِدُونَ وَلَٰكِن لَّا يَشْعُرُونَ"
     },
    {
      "number": 13,
      "text": "وَإِذَا قِيلَ لَهُمْ ءَامِنُوا۟ كَمَآ ءَامَنَ ٱلنَّاسُ قَالُوٓا۟ أَنُؤْمِنُ كَمَآ ءَامَنَ ٱلسُّفَهَآءُ أَلَآ إِنَّهُمْ هُمُ ٱلسُّفَهَآءُ وَلَٰكِن لَّا يَعْلَمُونَ"
     },
    {
      "number": 14,
      "text": "وَإِذَا لَقُوا۟ ٱلَّذِينَ ءَامَنُوا۟ قَالُوٓا۟ ءَامَنَّا وَإِذَا خَلَوْا۟ إِلَىٰ شَيَٰطِينِهِمْ قَالُوٓا۟ إِنَّا مَعَكُمْ إِنَّمَا نَحْنُ مُسْتَهْزِءُونَ"},
    {
      "number": 15,
      "text": "ٱللَّهُ يَسْتَهْزِئُ بِهِمْ وَيَمُدُّهُمْ فِى طُغْيَٰنِهِمْ يَعْمَهُونَ" },
    {
      "number": 16,
      "text": "أُو۟لَٰٓئِكَ ٱلَّذِينَ ٱشْتَرَوُا۟ ٱلضَّلَٰلَةَ بِٱلْهُدَىٰ فَمَا رَبِحَت تِّجَٰرَتُهُمْ وَمَا كَانُوا۟ مُهْتَدِينَ"
         },
    {
      "number": 17,
      "text": "مَثَلُهُمْ كَمَثَلِ ٱلَّذِى ٱسْتَوْقَدَ نَارًا فَلَمَّآ أَضَآءَتْ مَا حَوْلَهُۥ ذَهَبَ ٱللَّهُ بِنُورِهِمْ وَتَرَكَهُمْ فِى ظُلُمَٰتٍ لَّا يُبْصِرُونَ"},
    {
      "number": 18,
      "text": "صُمٌّۢ بُكْمٌ عُمْىٌ فَهُمْ لَا يَرْجِعُونَ"  },
    {
      "number": 19,
      "text": "أَوْ كَصَيِّبٍ مِّنَ ٱلسَّمَآءِ فِيهِ ظُلُمَٰتٌ وَرَعْدٌ وَبَرْقٌ يَجْعَلُونَ أَصَٰبِعَهُمْ فِىٓ ءَاذَانِهِم مِّنَ ٱلصَّوَٰعِقِ حَذَرَ ٱلْمَوْتِ وَٱللَّهُ مُحِيطٌۢ بِٱلْكَٰفِرِينَ"},
    {
      "number": 20,
      "text": "يَكَادُ ٱلْبَرْقُ يَخْطَفُ أَبْصَٰرَهُمْ كُلَّمَآ أَضَآءَ لَهُم مَّشَوْا۟ فِيهِ وَإِذَآ أَظْلَمَ عَلَيْهِمْ قَامُوا۟ وَلَوْ شَآءَ ٱللَّهُ لَذَهَبَ بِسَمْعِهِمْ وَأَبْصَٰرِهِمْ إِنَّ ٱللَّهَ عَلَىٰ كُلِّ شَىْءٍ قَدِيرٌ"
      
      
    },
    {
      "number": 21,
      "text": "يَٰٓأَيُّهَا ٱلنَّاسُ ٱعْبُدُوا۟ رَبَّكُمُ ٱلَّذِى خَلَقَكُمْ وَٱلَّذِينَ مِن قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُونَ"
      
      
    },
    {
      "number": 22,
      "text": "ٱلَّذِى جَعَلَ لَكُمُ ٱلْأَرْضَ فِرَٰشًا وَٱلسَّمَآءَ بِنَآءً وَأَنزَلَ مِنَ ٱلسَّمَآءِ مَآءً فَأَخْرَجَ بِهِۦ مِنَ ٱلثَّمَرَٰتِ رِزْقًا لَّكُمْ فَلَا تَجْعَلُوا۟ لِلَّهِ أَندَادًا وَأَنتُمْ تَعْلَمُونَ"
      
      
    },
    {
      "number": 23,
      "text": "وَإِن كُنتُمْ فِى رَيْبٍ مِّمَّا نَزَّلْنَا عَلَىٰ عَبْدِنَا فَأْتُوا۟ بِسُورَةٍ مِّن مِّثْلِهِۦ وَٱدْعُوا۟ شُهَدَآءَكُم مِّن دُونِ ٱللَّهِ إِن كُنتُمْ صَٰدِقِينَ"
      
      
    },
    {
      "number": 24,
      "text": "فَإِن لَّمْ تَفْعَلُوا۟ وَلَن تَفْعَلُوا۟ فَٱتَّقُوا۟ ٱلنَّارَ ٱلَّتِى وَقُودُهَا ٱلنَّاسُ وَٱلْحِجَارَةُ أُعِدَّتْ لِلْكَٰفِرِينَ"
      
      
    },
    {
      "number": 25,
      "text": "وَبَشِّرِ ٱلَّذِينَ ءَامَنُوا۟ وَعَمِلُوا۟ ٱلصَّٰلِحَٰتِ أَنَّ لَهُمْ جَنَّٰتٍ تَجْرِى مِن تَحْتِهَا ٱلْأَنْهَٰرُ كُلَّمَا رُزِقُوا۟ مِنْهَا مِن ثَمَرَةٍ رِّزْقًا قَالُوا۟ هَٰذَا ٱلَّذِى رُزِقْنَا مِن قَبْلُ وَأُتُوا۟ بِهِۦ مُتَشَٰبِهًا وَلَهُمْ فِيهَآ أَزْوَٰجٌ مُّطَهَّرَةٌ وَهُمْ فِيهَا خَٰلِدُونَ"
      
      
    },
    {
      "number": 26,
      "text": "إِنَّ ٱللَّهَ لَا يَسْتَحْىِۦٓ أَن يَضْرِبَ مَثَلًا مَّا بَعُوضَةً فَمَا فَوْقَهَا فَأَمَّا ٱلَّذِينَ ءَامَنُوا۟ فَيَعْلَمُونَ أَنَّهُ ٱلْحَقُّ مِن رَّبِّهِمْ وَأَمَّا ٱلَّذِينَ كَفَرُوا۟ فَيَقُولُونَ مَاذَآ أَرَادَ ٱللَّهُ بِهَٰذَا مَثَلًا يُضِلُّ بِهِۦ كَثِيرًا وَيَهْدِى بِهِۦ كَثِيرًا وَمَا يُضِلُّ بِهِۦٓ إِلَّا ٱلْفَٰسِقِينَ"
      
      
    },
    {
      "number": 27,
      "text": "ٱلَّذِينَ يَنقُضُونَ عَهْدَ ٱللَّهِ مِنۢ بَعْدِ مِيثَٰقِهِۦ وَيَقْطَعُونَ مَآ أَمَرَ ٱللَّهُ بِهِۦٓ أَن يُوصَلَ وَيُفْسِدُونَ فِى ٱلْأَرْضِ أُو۟لَٰٓئِكَ هُمُ ٱلْخَٰسِرُونَ"
      
      
    },
    {
      "number": 28,
      "text": "كَيْفَ تَكْفُرُونَ بِٱللَّهِ وَكُنتُمْ أَمْوَٰتًا فَأَحْيَٰكُمْ ثُمَّ يُمِيتُكُمْ ثُمَّ يُحْيِيكُمْ ثُمَّ إِلَيْهِ تُرْجَعُونَ"
      
      
    },
    {
      "number": 29,
      "text": "هُوَ ٱلَّذِى خَلَقَ لَكُم مَّا فِى ٱلْأَرْضِ جَمِيعًا ثُمَّ ٱسْتَوَىٰٓ إِلَى ٱلسَّمَآءِ فَسَوَّىٰهُنَّ سَبْعَ سَمَٰوَٰتٍ وَهُوَ بِكُلِّ شَىْءٍ عَلِيمٌ"
      
      
    },
    {
      "number": 30,
      "text": "وَإِذْ قَالَ رَبُّكَ لِلْمَلَٰٓئِكَةِ إِنِّى جَاعِلٌ فِى ٱلْأَرْضِ خَلِيفَةً قَالُوٓا۟ أَتَجْعَلُ فِيهَا مَن يُفْسِدُ فِيهَا وَيَسْفِكُ ٱلدِّمَآءَ وَنَحْنُ نُسَبِّحُ بِحَمْدِكَ وَنُقَدِّسُ لَكَ قَالَ إِنِّىٓ أَعْلَمُ مَا لَا تَعْلَمُونَ"
      
      
    },
    {
      "number": 31,
      "text": "وَعَلَّمَ ءَادَمَ ٱلْأَسْمَآءَ كُلَّهَا ثُمَّ عَرَضَهُمْ عَلَى ٱلْمَلَٰٓئِكَةِ فَقَالَ أَنۢبِـُٔونِى بِأَسْمَآءِ هَٰٓؤُلَآءِ إِن كُنتُمْ صَٰدِقِينَ"
      
      
    },
    {
      "number": 32,
      "text": "قَالُوا۟ سُبْحَٰنَكَ لَا عِلْمَ لَنَآ إِلَّا مَا عَلَّمْتَنَآ إِنَّكَ أَنتَ ٱلْعَلِيمُ ٱلْحَكِيمُ"
      
      
    },
    {
      "number": 33,
      "text": "قَالَ يَٰٓـَٔادَمُ أَنۢبِئْهُم بِأَسْمَآئِهِمْ فَلَمَّآ أَنۢبَأَهُم بِأَسْمَآئِهِمْ قَالَ أَلَمْ أَقُل لَّكُمْ إِنِّىٓ أَعْلَمُ غَيْبَ ٱلسَّمَٰوَٰتِ وَٱلْأَرْضِ وَأَعْلَمُ مَا تُبْدُونَ وَمَا كُنتُمْ تَكْتُمُونَ"
      
      
    },
    {
      "number": 34,
      "text": "وَإِذْ قُلْنَا لِلْمَلَٰٓئِكَةِ ٱسْجُدُوا۟ لِءَادَمَ فَسَجَدُوٓا۟ إِلَّآ إِبْلِيسَ أَبَىٰ وَٱسْتَكْبَرَ وَكَانَ مِنَ ٱلْكَٰفِرِينَ"
      
      
    },
    {
      "number": 35,
      "text": "وَقُلْنَا يَٰٓـَٔادَمُ ٱسْكُنْ أَنتَ وَزَوْجُكَ ٱلْجَنَّةَ وَكُلَا مِنْهَا رَغَدًا حَيْثُ شِئْتُمَا وَلَا تَقْرَبَا هَٰذِهِ ٱلشَّجَرَةَ فَتَكُونَا مِنَ ٱلظَّٰلِمِينَ"
      
      
    },
    {
      "number": 36,
      "text": "فَأَزَلَّهُمَا ٱلشَّيْطَٰنُ عَنْهَا فَأَخْرَجَهُمَا مِمَّا كَانَا فِيهِ وَقُلْنَا ٱهْبِطُوا۟ بَعْضُكُمْ لِبَعْضٍ عَدُوٌّ وَلَكُمْ فِى ٱلْأَرْضِ مُسْتَقَرٌّ وَمَتَٰعٌ إِلَىٰ حِينٍ"
      
      
    },
    {
      "number": 37,
      "text": "فَتَلَقَّىٰٓ ءَادَمُ مِن رَّبِّهِۦ كَلِمَٰتٍ فَتَابَ عَلَيْهِ إِنَّهُۥ هُوَ ٱلتَّوَّابُ ٱلرَّحِيمُ"
      
      
    },
    {
      "number": 38,
      "text": "قُلْنَا ٱهْبِطُوا۟ مِنْهَا جَمِيعًا فَإِمَّا يَأْتِيَنَّكُم مِّنِّى هُدًى فَمَن تَبِعَ هُدَاىَ فَلَا خَوْفٌ عَلَيْهِمْ وَلَا هُمْ يَحْزَنُونَ"
      
      
    },
    {
      "number": 39,
      "text": "وَٱلَّذِينَ كَفَرُوا۟ وَكَذَّبُوا۟ بِـَٔايَٰتِنَآ أُو۟لَٰٓئِكَ أَصْحَٰبُ ٱلنَّارِ هُمْ فِيهَا خَٰلِدُونَ"
      
      
    },
    {
      "number": 40,
      "text": "يَٰبَنِىٓ إِسْرَٰٓءِيلَ ٱذْكُرُوا۟ نِعْمَتِىَ ٱلَّتِىٓ أَنْعَمْتُ عَلَيْكُمْ وَأَوْفُوا۟ بِعَهْدِىٓ أُوفِ بِعَهْدِكُمْ وَإِيَّٰىَ فَٱرْهَبُونِ"
      
      
    },
    {
      "number": 41,
      "text": "وَءَامِنُوا۟ بِمَآ أَنزَلْتُ مُصَدِّقًا لِّمَا مَعَكُمْ وَلَا تَكُونُوٓا۟ أَوَّلَ كَافِرٍۭ بِهِۦ وَلَا تَشْتَرُوا۟ بِـَٔايَٰتِى ثَمَنًا قَلِيلًا وَإِيَّٰىَ فَٱتَّقُونِ"
      
      
    },
    {
      "number": 42,
      "text": "وَلَا تَلْبِسُوا۟ ٱلْحَقَّ بِٱلْبَٰطِلِ وَتَكْتُمُوا۟ ٱلْحَقَّ وَأَنتُمْ تَعْلَمُونَ"
      
      
    },
    {
      "number": 43,
      "text": "وَأَقِيمُوا۟ ٱلصَّلَوٰةَ وَءَاتُوا۟ ٱلزَّكَوٰةَ وَٱرْكَعُوا۟ مَعَ ٱلرَّٰكِعِينَ"
      
      
    },
    {
      "number": 44,
      "text": "أَتَأْمُرُونَ ٱلنَّاسَ بِٱلْبِرِّ وَتَنسَوْنَ أَنفُسَكُمْ وَأَنتُمْ تَتْلُونَ ٱلْكِتَٰبَ أَفَلَا تَعْقِلُونَ"
      
      
    },
    {
      "number": 45,
      "text": "وَٱسْتَعِينُوا۟ بِٱلصَّبْرِ وَٱلصَّلَوٰةِ وَإِنَّهَا لَكَبِيرَةٌ إِلَّا عَلَى ٱلْخَٰشِعِينَ"
      
      
    },
    {
      "number": 46,
      "text": "ٱلَّذِينَ يَظُنُّونَ أَنَّهُم مُّلَٰقُوا۟ رَبِّهِمْ وَأَنَّهُمْ إِلَيْهِ رَٰجِعُونَ"
      
      
    },
    {
      "number": 47,
      "text": "يَٰبَنِىٓ إِسْرَٰٓءِيلَ ٱذْكُرُوا۟ نِعْمَتِىَ ٱلَّتِىٓ أَنْعَمْتُ عَلَيْكُمْ وَأَنِّى فَضَّلْتُكُمْ عَلَى ٱلْعَٰلَمِينَ"
      
      
    },
    {
      "number": 48,
      "text": "وَٱتَّقُوا۟ يَوْمًا لَّا تَجْزِى نَفْسٌ عَن نَّفْسٍ شَيْـًٔا وَلَا يُقْبَلُ مِنْهَا شَفَٰعَةٌ وَلَا يُؤْخَذُ مِنْهَا عَدْلٌ وَلَا هُمْ يُنصَرُونَ"
      
      
    },
    {
      "number": 49,
      "text": "وَإِذْ نَجَّيْنَٰكُم مِّنْ ءَالِ فِرْعَوْنَ يَسُومُونَكُمْ سُوٓءَ ٱلْعَذَابِ يُذَبِّحُونَ أَبْنَآءَكُمْ وَيَسْتَحْيُونَ نِسَآءَكُمْ وَفِى ذَٰلِكُم بَلَآءٌ مِّن رَّبِّكُمْ عَظِيمٌ"
      
      
    },
    {
      "number": 50,
      "text": "وَإِذْ فَرَقْنَا بِكُمُ ٱلْبَحْرَ فَأَنجَيْنَٰكُمْ وَأَغْرَقْنَآ ءَالَ فِرْعَوْنَ وَأَنتُمْ تَنظُرُونَ"
      
      
    },
    {
      "number": 51,
      "text": "وَإِذْ وَٰعَدْنَا مُوسَىٰٓ أَرْبَعِينَ لَيْلَةً ثُمَّ ٱتَّخَذْتُمُ ٱلْعِجْلَ مِنۢ بَعْدِهِۦ وَأَنتُمْ ظَٰلِمُونَ"
      
      
    },
    {
      "number": 52,
      "text": "ثُمَّ عَفَوْنَا عَنكُم مِّنۢ بَعْدِ ذَٰلِكَ لَعَلَّكُمْ تَشْكُرُونَ"
      
    },
    {
      "number": 53,
      "text": "وَإِذْ ءَاتَيْنَا مُوسَى ٱلْكِتَٰبَ وَٱلْفُرْقَانَ لَعَلَّكُمْ تَهْتَدُونَ"
      
      
    },
    {
      "number": 54,
      "text": "وَإِذْ قَالَ مُوسَىٰ لِقَوْمِهِۦ يَٰقَوْمِ إِنَّكُمْ ظَلَمْتُمْ أَنفُسَكُم بِٱتِّخَاذِكُمُ ٱلْعِجْلَ فَتُوبُوٓا۟ إِلَىٰ بَارِئِكُمْ فَٱقْتُلُوٓا۟ أَنفُسَكُمْ ذَٰلِكُمْ خَيْرٌ لَّكُمْ عِندَ بَارِئِكُمْ فَتَابَ عَلَيْكُمْ إِنَّهُۥ هُوَ ٱلتَّوَّابُ ٱلرَّحِيمُ"
      
      
    },
    {
      "number": 55,
      "text": "وَإِذْ قُلْتُمْ يَٰمُوسَىٰ لَن نُّؤْمِنَ لَكَ حَتَّىٰ نَرَى ٱللَّهَ جَهْرَةً فَأَخَذَتْكُمُ ٱلصَّٰعِقَةُ وَأَنتُمْ تَنظُرُونَ"
      
      
    },
    {
      "number": 56,
      "text": "ثُمَّ بَعَثْنَٰكُم مِّنۢ بَعْدِ مَوْتِكُمْ لَعَلَّكُمْ تَشْكُرُونَ"
      
      
    },
    {
      "number": 57,
      "text": "وَظَلَّلْنَا عَلَيْكُمُ ٱلْغَمَامَ وَأَنزَلْنَا عَلَيْكُمُ ٱلْمَنَّ وَٱلسَّلْوَىٰ كُلُوا۟ مِن طَيِّبَٰتِ مَا رَزَقْنَٰكُمْ وَمَا ظَلَمُونَا وَلَٰكِن كَانُوٓا۟ أَنفُسَهُمْ يَظْلِمُونَ"
      
      
    },
    {
      "number": 58,
      "text": "وَإِذْ قُلْنَا ٱدْخُلُوا۟ هَٰذِهِ ٱلْقَرْيَةَ فَكُلُوا۟ مِنْهَا حَيْثُ شِئْتُمْ رَغَدًا وَٱدْخُلُوا۟ ٱلْبَابَ سُجَّدًا وَقُولُوا۟ حِطَّةٌ نَّغْفِرْ لَكُمْ خَطَٰيَٰكُمْ وَسَنَزِيدُ ٱلْمُحْسِنِينَ"
      
      
    },
    {
      "number": 59,
      "text": "فَبَدَّلَ ٱلَّذِينَ ظَلَمُوا۟ قَوْلًا غَيْرَ ٱلَّذِى قِيلَ لَهُمْ فَأَنزَلْنَا عَلَى ٱلَّذِينَ ظَلَمُوا۟ رِجْزًا مِّنَ ٱلسَّمَآءِ بِمَا كَانُوا۟ يَفْسُقُونَ"
      
      
    },
    {
      "number": 60,
      "text": "وَإِذِ ٱسْتَسْقَىٰ مُوسَىٰ لِقَوْمِهِۦ فَقُلْنَا ٱضْرِب بِّعَصَاكَ ٱلْحَجَرَ فَٱنفَجَرَتْ مِنْهُ ٱثْنَتَا عَشْرَةَ عَيْنًا قَدْ عَلِمَ كُلُّ أُنَاسٍ مَّشْرَبَهُمْ كُلُوا۟ وَٱشْرَبُوا۟ مِن رِّزْقِ ٱللَّهِ وَلَا تَعْثَوْا۟ فِى ٱلْأَرْضِ مُفْسِدِينَ"
      
      
    },
    {
      "number": 61,
      "text": "وَإِذْ قُلْتُمْ يَٰمُوسَىٰ لَن نَّصْبِرَ عَلَىٰ طَعَامٍ وَٰحِدٍ فَٱدْعُ لَنَا رَبَّكَ يُخْرِجْ لَنَا مِمَّا تُنۢبِتُ ٱلْأَرْضُ مِنۢ بَقْلِهَا وَقِثَّآئِهَا وَفُومِهَا وَعَدَسِهَا وَبَصَلِهَا قَالَ أَتَسْتَبْدِلُونَ ٱلَّذِى هُوَ أَدْنَىٰ بِٱلَّذِى هُوَ خَيْرٌ ٱهْبِطُوا۟ مِصْرًا فَإِنَّ لَكُم مَّا سَأَلْتُمْ وَضُرِبَتْ عَلَيْهِمُ ٱلذِّلَّةُ وَٱلْمَسْكَنَةُ وَبَآءُو بِغَضَبٍ مِّنَ ٱللَّهِ ذَٰلِكَ بِأَنَّهُمْ كَانُوا۟ يَكْفُرُونَ بِـَٔايَٰتِ ٱللَّهِ وَيَقْتُلُونَ ٱلنَّبِيِّۦنَ بِغَيْرِ ٱلْحَقِّ ذَٰلِكَ بِمَا عَصَوا۟ وَّكَانُوا۟ يَعْتَدُونَ"
      
      
    },
    {
      "number": 62,
      "text": "إِنَّ ٱلَّذِينَ ءَامَنُوا۟ وَٱلَّذِينَ هَادُوا۟ وَٱلنَّصَٰرَىٰ وَٱلصَّٰبِـِٔينَ مَنْ ءَامَنَ بِٱللَّهِ وَٱلْيَوْمِ ٱلْءَاخِرِ وَعَمِلَ صَٰلِحًا فَلَهُمْ أَجْرُهُمْ عِندَ رَبِّهِمْ وَلَا خَوْفٌ عَلَيْهِمْ وَلَا هُمْ يَحْزَنُونَ"
      
      
    },
    {
      "number": 63,
      "text": "وَإِذْ أَخَذْنَا مِيثَٰقَكُمْ وَرَفَعْنَا فَوْقَكُمُ ٱلطُّورَ خُذُوا۟ مَآ ءَاتَيْنَٰكُم بِقُوَّةٍ وَٱذْكُرُوا۟ مَا فِيهِ لَعَلَّكُمْ تَتَّقُونَ"
      
      
    },
    {
      "number": 64,
      "text": "ثُمَّ تَوَلَّيْتُم مِّنۢ بَعْدِ ذَٰلِكَ فَلَوْلَا فَضْلُ ٱللَّهِ عَلَيْكُمْ وَرَحْمَتُهُۥ لَكُنتُم مِّنَ ٱلْخَٰسِرِينَ"
      
      
    },
    {
      "number": 65,
      "text": "وَلَقَدْ عَلِمْتُمُ ٱلَّذِينَ ٱعْتَدَوْا۟ مِنكُمْ فِى ٱلسَّبْتِ فَقُلْنَا لَهُمْ كُونُوا۟ قِرَدَةً خَٰسِـِٔينَ"
      
      
    },
    {
      "number": 66,
      "text": "فَجَعَلْنَٰهَا نَكَٰلًا لِّمَا بَيْنَ يَدَيْهَا وَمَا خَلْفَهَا وَمَوْعِظَةً لِّلْمُتَّقِينَ"
      
      
    },
    {
      "number": 67,
      "text": "وَإِذْ قَالَ مُوسَىٰ لِقَوْمِهِۦٓ إِنَّ ٱللَّهَ يَأْمُرُكُمْ أَن تَذْبَحُوا۟ بَقَرَةً قَالُوٓا۟ أَتَتَّخِذُنَا هُزُوًا قَالَ أَعُوذُ بِٱللَّهِ أَنْ أَكُونَ مِنَ ٱلْجَٰهِلِينَ"
      
      
    },
    {
      "number": 68,
      "text": "قَالُوا۟ ٱدْعُ لَنَا رَبَّكَ يُبَيِّن لَّنَا مَا هِىَ قَالَ إِنَّهُۥ يَقُولُ إِنَّهَا بَقَرَةٌ لَّا فَارِضٌ وَلَا بِكْرٌ عَوَانٌۢ بَيْنَ ذَٰلِكَ فَٱفْعَلُوا۟ مَا تُؤْمَرُونَ"
      
      
    },
    {
      "number": 69,
      "text": "قَالُوا۟ ٱدْعُ لَنَا رَبَّكَ يُبَيِّن لَّنَا مَا لَوْنُهَا قَالَ إِنَّهُۥ يَقُولُ إِنَّهَا بَقَرَةٌ صَفْرَآءُ فَاقِعٌ لَّوْنُهَا تَسُرُّ ٱلنَّٰظِرِينَ"
      
      
    },
    {
      "number": 70,
      "text": "قَالُوا۟ ٱدْعُ لَنَا رَبَّكَ يُبَيِّن لَّنَا مَا هِىَ إِنَّ ٱلْبَقَرَ تَشَٰبَهَ عَلَيْنَا وَإِنَّآ إِن شَآءَ ٱللَّهُ لَمُهْتَدُونَ"
      
      
    },
    {
      "number": 71,
      "text": "قَالَ إِنَّهُۥ يَقُولُ إِنَّهَا بَقَرَةٌ لَّا ذَلُولٌ تُثِيرُ ٱلْأَرْضَ وَلَا تَسْقِى ٱلْحَرْثَ مُسَلَّمَةٌ لَّا شِيَةَ فِيهَا قَالُوا۟ ٱلْـَٰٔنَ جِئْتَ بِٱلْحَقِّ فَذَبَحُوهَا وَمَا كَادُوا۟ يَفْعَلُونَ"
      
      
    },
    {
      "number": 72,
      "text": "وَإِذْ قَتَلْتُمْ نَفْسًا فَٱدَّٰرَْٰٔتُمْ فِيهَا وَٱللَّهُ مُخْرِجٌ مَّا كُنتُمْ تَكْتُمُونَ"
      
      
    },
    {
      "number": 73,
      "text": "فَقُلْنَا ٱضْرِبُوهُ بِبَعْضِهَا كَذَٰلِكَ يُحْىِ ٱللَّهُ ٱلْمَوْتَىٰ وَيُرِيكُمْ ءَايَٰتِهِۦ لَعَلَّكُمْ تَعْقِلُونَ"
      
      
    },
    {
      "number": 74,
      "text": "ثُمَّ قَسَتْ قُلُوبُكُم مِّنۢ بَعْدِ ذَٰلِكَ فَهِىَ كَٱلْحِجَارَةِ أَوْ أَشَدُّ قَسْوَةً وَإِنَّ مِنَ ٱلْحِجَارَةِ لَمَا يَتَفَجَّرُ مِنْهُ ٱلْأَنْهَٰرُ وَإِنَّ مِنْهَا لَمَا يَشَّقَّقُ فَيَخْرُجُ مِنْهُ ٱلْمَآءُ وَإِنَّ مِنْهَا لَمَا يَهْبِطُ مِنْ خَشْيَةِ ٱللَّهِ وَمَا ٱللَّهُ بِغَٰفِلٍ عَمَّا تَعْمَلُونَ"
      
      
    },
    {
      "number": 75,
      "text": "أَفَتَطْمَعُونَ أَن يُؤْمِنُوا۟ لَكُمْ وَقَدْ كَانَ فَرِيقٌ مِّنْهُمْ يَسْمَعُونَ كَلَٰمَ ٱللَّهِ ثُمَّ يُحَرِّفُونَهُۥ مِنۢ بَعْدِ مَا عَقَلُوهُ وَهُمْ يَعْلَمُونَ"
      
      
    },
    {
      "number": 76,
      "text": "وَإِذَا لَقُوا۟ ٱلَّذِينَ ءَامَنُوا۟ قَالُوٓا۟ ءَامَنَّا وَإِذَا خَلَا بَعْضُهُمْ إِلَىٰ بَعْضٍ قَالُوٓا۟ أَتُحَدِّثُونَهُم بِمَا فَتَحَ ٱللَّهُ عَلَيْكُمْ لِيُحَآجُّوكُم بِهِۦ عِندَ رَبِّكُمْ أَفَلَا تَعْقِلُونَ"
      
      
    },
    {
      "number": 77,
      "text": "أَوَلَا يَعْلَمُونَ أَنَّ ٱللَّهَ يَعْلَمُ مَا يُسِرُّونَ وَمَا يُعْلِنُونَ"
      
      
    },
    {
      "number": 78,
      "text": "وَمِنْهُمْ أُمِّيُّونَ لَا يَعْلَمُونَ ٱلْكِتَٰبَ إِلَّآ أَمَانِىَّ وَإِنْ هُمْ إِلَّا يَظُنُّونَ"
      
      
    },
    {
      "number": 79,
      "text": "فَوَيْلٌ لِّلَّذِينَ يَكْتُبُونَ ٱلْكِتَٰبَ بِأَيْدِيهِمْ ثُمَّ يَقُولُونَ هَٰذَا مِنْ عِندِ ٱللَّهِ لِيَشْتَرُوا۟ بِهِۦ ثَمَنًا قَلِيلًا فَوَيْلٌ لَّهُم مِّمَّا كَتَبَتْ أَيْدِيهِمْ وَوَيْلٌ لَّهُم مِّمَّا يَكْسِبُونَ"
      
      
    },
    {
      "number": 80,
      "text": "وَقَالُوا۟ لَن تَمَسَّنَا ٱلنَّارُ إِلَّآ أَيَّامًا مَّعْدُودَةً قُلْ أَتَّخَذْتُمْ عِندَ ٱللَّهِ عَهْدًا فَلَن يُخْلِفَ ٱللَّهُ عَهْدَهُۥٓ أَمْ تَقُولُونَ عَلَى ٱللَّهِ مَا لَا تَعْلَمُونَ"
      
      
    },
    {
      "number": 81,
      "text": "بَلَىٰ مَن كَسَبَ سَيِّئَةً وَأَحَٰطَتْ بِهِۦ خَطِيٓـَٔتُهُۥ فَأُو۟لَٰٓئِكَ أَصْحَٰبُ ٱلنَّارِ هُمْ فِيهَا خَٰلِدُونَ"
      
      
    },
    {
      "number": 82,
      "text": "وَٱلَّذِينَ ءَامَنُوا۟ وَعَمِلُوا۟ ٱلصَّٰلِحَٰتِ أُو۟لَٰٓئِكَ أَصْحَٰبُ ٱلْجَنَّةِ هُمْ فِيهَا خَٰلِدُونَ"
      
      
    },
    {
      "number": 83,
      "text": "وَإِذْ أَخَذْنَا مِيثَٰقَ بَنِىٓ إِسْرَٰٓءِيلَ لَا تَعْبُدُونَ إِلَّا ٱللَّهَ وَبِٱلْوَٰلِدَيْنِ إِحْسَانًا وَذِى ٱلْقُرْبَىٰ وَٱلْيَتَٰمَىٰ وَٱلْمَسَٰكِينِ وَقُولُوا۟ لِلنَّاسِ حُسْنًا وَأَقِيمُوا۟ ٱلصَّلَوٰةَ وَءَاتُوا۟ ٱلزَّكَوٰةَ ثُمَّ تَوَلَّيْتُمْ إِلَّا قَلِيلًا مِّنكُمْ وَأَنتُم مُّعْرِضُونَ"
      
      
    },
    {
      "number": 84,
      "text": "وَإِذْ أَخَذْنَا مِيثَٰقَكُمْ لَا تَسْفِكُونَ دِمَآءَكُمْ وَلَا تُخْرِجُونَ أَنفُسَكُم مِّن دِيَٰرِكُمْ ثُمَّ أَقْرَرْتُمْ وَأَنتُمْ تَشْهَدُونَ"
      
      
    },
    {
      "number": 85,
      "text": "ثُمَّ أَنتُمْ هَٰٓؤُلَآءِ تَقْتُلُونَ أَنفُسَكُمْ وَتُخْرِجُونَ فَرِيقًا مِّنكُم مِّن دِيَٰرِهِمْ تَظَٰهَرُونَ عَلَيْهِم بِٱلْإِثْمِ وَٱلْعُدْوَٰنِ وَإِن يَأْتُوكُمْ أُسَٰرَىٰ تُفَٰدُوهُمْ وَهُوَ مُحَرَّمٌ عَلَيْكُمْ إِخْرَاجُهُمْ أَفَتُؤْمِنُونَ بِبَعْضِ ٱلْكِتَٰبِ وَتَكْفُرُونَ بِبَعْضٍ فَمَا جَزَآءُ مَن يَفْعَلُ ذَٰلِكَ مِنكُمْ إِلَّا خِزْىٌ فِى ٱلْحَيَوٰةِ ٱلدُّنْيَا وَيَوْمَ ٱلْقِيَٰمَةِ يُرَدُّونَ إِلَىٰٓ أَشَدِّ ٱلْعَذَابِ وَمَا ٱللَّهُ بِغَٰفِلٍ عَمَّا تَعْمَلُونَ"
      
      
    },
    {
      "number": 86,
      "text": "أُو۟لَٰٓئِكَ ٱلَّذِينَ ٱشْتَرَوُا۟ ٱلْحَيَوٰةَ ٱلدُّنْيَا بِٱلْءَاخِرَةِ فَلَا يُخَفَّفُ عَنْهُمُ ٱلْعَذَابُ وَلَا هُمْ يُنصَرُونَ"
      
      
    },
    {
      "number": 87,
      "text": "وَلَقَدْ ءَاتَيْنَا مُوسَى ٱلْكِتَٰبَ وَقَفَّيْنَا مِنۢ بَعْدِهِۦ بِٱلرُّسُلِ وَءَاتَيْنَا عِيسَى ٱبْنَ مَرْيَمَ ٱلْبَيِّنَٰتِ وَأَيَّدْنَٰهُ بِرُوحِ ٱلْقُدُسِ أَفَكُلَّمَا جَآءَكُمْ رَسُولٌۢ بِمَا لَا تَهْوَىٰٓ أَنفُسُكُمُ ٱسْتَكْبَرْتُمْ فَفَرِيقًا كَذَّبْتُمْ وَفَرِيقًا تَقْتُلُونَ"
      
      
    },
    {
      "number": 88,
      "text": "وَقَالُوا۟ قُلُوبُنَا غُلْفٌۢ بَل لَّعَنَهُمُ ٱللَّهُ بِكُفْرِهِمْ فَقَلِيلًا مَّا يُؤْمِنُونَ"
      
      
    },
    {
      "number": 89,
      "text": "وَلَمَّا جَآءَهُمْ كِتَٰبٌ مِّنْ عِندِ ٱللَّهِ مُصَدِّقٌ لِّمَا مَعَهُمْ وَكَانُوا۟ مِن قَبْلُ يَسْتَفْتِحُونَ عَلَى ٱلَّذِينَ كَفَرُوا۟ فَلَمَّا جَآءَهُم مَّا عَرَفُوا۟ كَفَرُوا۟ بِهِۦ فَلَعْنَةُ ٱللَّهِ عَلَى ٱلْكَٰفِرِينَ"
      
      
    },
    {
      "number": 90,
      "text": "بِئْسَمَا ٱشْتَرَوْا۟ بِهِۦٓ أَنفُسَهُمْ أَن يَكْفُرُوا۟ بِمَآ أَنزَلَ ٱللَّهُ بَغْيًا أَن يُنَزِّلَ ٱللَّهُ مِن فَضْلِهِۦ عَلَىٰ مَن يَشَآءُ مِنْ عِبَادِهِۦ فَبَآءُو بِغَضَبٍ عَلَىٰ غَضَبٍ وَلِلْكَٰفِرِينَ عَذَابٌ مُّهِينٌ"
      
      
    },
    {
      "number": 91,
      "text": "وَإِذَا قِيلَ لَهُمْ ءَامِنُوا۟ بِمَآ أَنزَلَ ٱللَّهُ قَالُوا۟ نُؤْمِنُ بِمَآ أُنزِلَ عَلَيْنَا وَيَكْفُرُونَ بِمَا وَرَآءَهُۥ وَهُوَ ٱلْحَقُّ مُصَدِّقًا لِّمَا مَعَهُمْ قُلْ فَلِمَ تَقْتُلُونَ أَنۢبِيَآءَ ٱللَّهِ مِن قَبْلُ إِن كُنتُم مُّؤْمِنِينَ"
      
      
    },
    {
      "number": 92,
      "text": "وَلَقَدْ جَآءَكُم مُّوسَىٰ بِٱلْبَيِّنَٰتِ ثُمَّ ٱتَّخَذْتُمُ ٱلْعِجْلَ مِنۢ بَعْدِهِۦ وَأَنتُمْ ظَٰلِمُونَ"
      
      
    },
    {
      "number": 93,
      "text": "وَإِذْ أَخَذْنَا مِيثَٰقَكُمْ وَرَفَعْنَا فَوْقَكُمُ ٱلطُّورَ خُذُوا۟ مَآ ءَاتَيْنَٰكُم بِقُوَّةٍ وَٱسْمَعُوا۟ قَالُوا۟ سَمِعْنَا وَعَصَيْنَا وَأُشْرِبُوا۟ فِى قُلُوبِهِمُ ٱلْعِجْلَ بِكُفْرِهِمْ قُلْ بِئْسَمَا يَأْمُرُكُم بِهِۦٓ إِيمَٰنُكُمْ إِن كُنتُم مُّؤْمِنِينَ"
      
      
    },
    {
      "number": 94,
      "text": "قُلْ إِن كَانَتْ لَكُمُ ٱلدَّارُ ٱلْءَاخِرَةُ عِندَ ٱللَّهِ خَالِصَةً مِّن دُونِ ٱلنَّاسِ فَتَمَنَّوُا۟ ٱلْمَوْتَ إِن كُنتُمْ صَٰدِقِينَ"
      
      
    },
    {
      "number": 95,
      "text": "وَلَن يَتَمَنَّوْهُ أَبَدًۢا بِمَا قَدَّمَتْ أَيْدِيهِمْ وَٱللَّهُ عَلِيمٌۢ بِٱلظَّٰلِمِينَ"
      
      
    },
    {
      "number": 96,
      "text": "وَلَتَجِدَنَّهُمْ أَحْرَصَ ٱلنَّاسِ عَلَىٰ حَيَوٰةٍ وَمِنَ ٱلَّذِينَ أَشْرَكُوا۟ يَوَدُّ أَحَدُهُمْ لَوْ يُعَمَّرُ أَلْفَ سَنَةٍ وَمَا هُوَ بِمُزَحْزِحِهِۦ مِنَ ٱلْعَذَابِ أَن يُعَمَّرَ وَٱللَّهُ بَصِيرٌۢ بِمَا يَعْمَلُونَ"
    },
    {
      "number": 97,
      "text": "قُلْ مَن كَانَ عَدُوًّا لِّجِبْرِيلَ فَإِنَّهُۥ نَزَّلَهُۥ عَلَىٰ قَلْبِكَ بِإِذْنِ ٱللَّهِ مُصَدِّقًا لِّمَا بَيْنَ يَدَيْهِ وَهُدًى وَبُشْرَىٰ لِلْمُؤْمِنِينَ"

    },
    {
      "number": 98,
      "text": "مَن كَانَ عَدُوًّا لِّلَّهِ وَمَلَٰٓئِكَتِهِۦ وَرُسُلِهِۦ وَجِبْرِيلَ وَمِيكَىٰلَ فَإِنَّ ٱللَّهَ عَدُوٌّ لِّلْكَٰفِرِينَ"
      },
    {
      "number": 99,
      "text": "وَلَقَدْ أَنزَلْنَآ إِلَيْكَ ءَايَٰتٍۭ بَيِّنَٰتٍ وَمَا يَكْفُرُ بِهَآ إِلَّا ٱلْفَٰسِقُونَ"
      },
    {
      "number": 100,
      "text": "أَوَكُلَّمَا عَٰهَدُوا۟ عَهْدًا نَّبَذَهُۥ فَرِيقٌ مِّنْهُم بَلْ أَكْثَرُهُمْ لَا يُؤْمِنُونَ"
      }]}""";