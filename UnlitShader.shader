Shader "Test/UnlitShader"
{
    
    Properties
    {
        _MainTex1 ("Main Texture1", 2D) = "white" {}
        _MainTex2 ("Main Texture2", 2D) = "white" {}
        _MainTex3 ("Main Texture3", 2D) = "white" {}
        _MaskTex  ("Mask Texture" , 2D)  = "black" {}
        _EmTex    ("Emission Texture",2D) = "black" {}
       

        _Color ("Emission color",     Color)= (1,1,1,1) 
        _VectorParam("Vector Param",Vector) = (1,0.5,0,0)

        _LightIntensity("Intensity",float)  = 1
        _EmissionRange ("Range",Range(0,1)) = 0
        
        _NormalMap     ("Normal Map", 2D)    = "bump" {}
    }
    SubShader
    {
        CGPROGRAM
        #pragma target 3.0
        #pragma surface surf Lambert

        sampler2D _MainTex1,_MainTex2,_MainTex3,_EmTex,_NormalMap;
        sampler2D _MaskTex;

        struct Input
        {
           fixed2 uv_MainTex1,uv_MainTex2,uv_MainTex3;
           fixed2 uv_MaskTex;
        };

        fixed3 _Color;
        fixed _EmissionRange;
        float _LightIntensity;
        void surf(Input input,inout SurfaceOutput output)
        {
            fixed3 mask = tex2D(_MaskTex, input.uv_MaskTex);
            fixed3 color = tex2D(_MainTex1, input.uv_MainTex1)*mask.r;
            color += tex2D(_MainTex2,input.uv_MainTex2)*mask.g;
            color +=tex2D(_MainTex3,input.uv_MainTex3)*mask.b;

            fixed3 emTex = tex2D(_EmTex,input.uv_MaskTex);
            half fadeMask = emTex;
            fadeMask = smoothstep(_EmissionRange*1.1,_EmissionRange*1.4,fadeMask);

            
            output.Albedo = color;
            
            output.Emission = fadeMask*emTex * _Color * _LightIntensity;
            output.Normal = UnpackNormal(tex2D(_NormalMap,input.uv_MaskTex));
        }
        
        ENDCG
        
    }
}

