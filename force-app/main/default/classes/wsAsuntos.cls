/**
 * @author oromero@ctconsulting.com.mx
 * @date 13/03/20
 * @group Asunto__c
 * @description Clase de Web service utilizado para crear y actualizar los Asuntos de SIO hacia Salesforce.
 */
@RestResource(urlMapping='/wsCrearAsuntos/*')
global with sharing class wsAsuntos {
	
    /*******************************************************************************************************
    * @description Metodo del Servicio web para crear los Asuntos de la correspondencia en salesforce
    * @param @HttpPost Objeto de tipo JSON en el cuerpo de la solicitud
    * @return Id del Asunto creado / actualizada o mensaje de error
    * @example
    * 
    */

    @HttpPost
    global static ResponseWrapper crearAsuntos(){
    RestRequest request = RestContext.request;
        RestResponse res = RestContext.response;
        ResponseWrapper response = new ResponseWrapper();
        List<WrapperAsuntos> jsonBody = new List<WrapperAsuntos>();
        List<Asunto__c> result = new List<Asunto__c>();
        List<Asunto__c> listAsunto = new List<Asunto__c>();
        List<Contact> listCont = new List<Contact>();
        
        Id idAsunto;
        String aux_claveArea;
        String aux_claveAsunto;
        String aux_ejecutivo;
        String aux_coordinador;
        String aux_idAsunto;
        String aux_IdSio;
        try{
            jsonBody = (List<WrapperAsuntos>) JSON.deserialize(request.requestBody.toString(),List<WrapperAsuntos>.class);
            System.debug('Antes de entrar al if jsonBody '+jsonBody);
            if(jsonBody.size() > 0 && jsonBody != null){
            System.debug('Despues de entrar al if jsonBody '+jsonBody);                
                for(WrapperAsuntos ids : jsonBody){
                    aux_claveArea = ids.ClaveArea;
                    aux_claveAsunto = ids.ClaveAsunto;
                    aux_coordinador = ids.Coordinador;
                    aux_ejecutivo = ids.Ejecutivo;
                    aux_IdSio = ids.Contacto;
                    aux_idAsunto = ids.IdAsunto;
                }
                result = [SELECT Clave_de_rea__c, ClaveAsunto__c, Estatus_del_Asunto__c, Fecha_de_Asunto__c, Id, Id_Asunto__c, Name
                    	FROM Asunto__c 
                        WHERE Id_Asunto__c =: aux_idAsunto];
                
                listCont = [SELECT Id, Id_SIO__c
                        FROM Contact 
                        WHERE Id_SIO__c =: aux_IdSio];

                if(result.size() > 0){
                    idAsunto = result[0].Id;
                }
                System.debug('Asunto existente ||' + result);
            }
            System.debug('Tamaño de la lista ||' + result.size());
            if(result.size() < 1){
                System.debug('Asunto encontrada result ||' + result);

                for(WrapperAsuntos listBody : jsonBody){
                    Asunto__c asunto = new Asunto__c();
                    
                    asunto.Clave_de_rea__c = Utils.getCatalogo('Clave__c', aux_claveArea, 'AreaPractica', null);
                    System.debug('Clave_de_rea__c' + asunto.Clave_de_rea__c);
                    asunto.ClaveAsunto__c = Utils.getCatalogo('Clave__c', null, null, null);
                    System.debug('ClaveAsunto__c' + asunto.ClaveAsunto__c);

                    if(listCont.size() > 0){
                        asunto.Contacto__c = listCont[0].Id;
                    }else{
                        response.status = 'Error';
                        response.message = 'No se encontro el Contacto asocioado al Asunto';
                        response.StatusCode = res.StatusCode = 404;
                    }
                    
                    asunto.Coordinador__c = Utils.getCatalogo('Id_principal__c', aux_coordinador, 'Usurarios_SIO', 'Coordinador__c');
                    System.debug('acc.Coordinador__c || ' + asunto.Coordinador__c);
                    asunto.Ejecutivo__c = Utils.getCatalogo('Id_principal__c', aux_ejecutivo, 'Usurarios_SIO', 'Ejecutivo__c');
                    System.debug('acc.Ejecutivo__c || ' + asunto.Ejecutivo__c);
                    asunto.Estatus_del_Asunto__c = listBody.EstatusAsunto;
                    asunto.Fecha_de_Asunto__c = listBody.FechaAsunto; // Format (YYYY-MM-DD)
                    asunto.Id_Asunto__c = listBody.IdAsunto;
                    asunto.Id_KWD_1__c = listBody.IdKWD1;
                    asunto.Id_KWD_2__c = listBody.IdKWD2;
                    asunto.Id_Legacy_Actor__c = listBody.IdLegacyActor;
                    asunto.Id_Legacy_de_Cliente__c = listBody.IdLegacyCliente;
                    asunto.Id_Legacy_de_Coordinador__c = listBody.IdLegacyCoordinador;
                    asunto.Id_Legacy_de_corresponsal__c = listBody.IdLegacyCorresponsal;
                    asunto.Id_Legacy_de_Demandado__c = listBody.IdLegacyDemandado;
                    asunto.Id_Legacy_de_Ejecutivo__c = listBody.IdLeagacyEjecutivo;
                    asunto.Id_Legacy_de_Facturar_a__c = listBody.IdLegacyFacturar_a;
                    asunto.Id_Legacy_de_Socio__c = listBody.IdLegacySocio;
                    asunto.IdLegacyTerceroPerjudicado__c = listBody.IdLegacyTerceroPerjudiado;
                    asunto.Id_Legacy_Titular__c = listBody.IdLegacyTitular;
                    asunto.Id_Legacy_de_Tercero_Interesado__c = listBody.IdLegacyTerceroInteresado;
                    asunto.Id_Pirncipal_de_Ejecutivo__c = listBody.IdPrincipalEjecutivo;
                    asunto.Id_Principal_Actor__c = listBody.IdPrincipalActor;
                    asunto.Id_Principal_de_Coordinador__c = listBody.IdPrincipalCoordinador;
                    asunto.Id_Principal_de_Demandado__c = listBody.IdPrincipalDemandado;
                    asunto.Id_Principal_de_Socio__c = listBody.IdPrincipaSocio;
                    asunto.IdPrincipalTerceroPerjudicado__c = listBody.IdPrincipaTerceroPerjudicado;
                    asunto.IdPrincipalCliente__c = listBody.IdPrincipalCliente;
                    asunto.IdPrincipalCorresponsal__c = listBody.IdPrincipalCorresonsal;
                    asunto.IdPrincipalFacturarA__c = listBody.IdPrincipalFacturar_a;
                    asunto.IdPrincipalTitular__c = listBody.IdPrincipalTitular;
                    asunto.Id_Pincipal_de_Tercero_Interesado__c = listBody.IdPincipalTerceroInteresado;
                    asunto.Name = listBody.IdAsunto;  // (20M0001) Se asigna el nombre
                    //Tercero_Perjudicado__c
                    //Tercero_Interesado__c
                    if(listBody.ClaveArea == null || listBody.ClaveArea == '' || aux_claveArea == null || aux_claveArea == ''){
                        response.status = 'Error';
                        response.message = 'El parámetro Clave de Area del Asunto es obligatorio, pero no tiene valor o es nulo';
                        response.StatusCode = res.StatusCode = 404;
                    }else if(listBody.ClaveAsunto == null || listBody.ClaveAsunto == '' || aux_claveAsunto == null || aux_claveAsunto == ''){
                        response.status = 'Error';
                        response.message = 'El parámetro Clave del Asunto es obligatorio, pero no tiene valor o es nulo';
                        response.StatusCode = res.StatusCode = 404;
                    }else if(listBody.Coordinador == null || listBody.Coordinador == ''){
                        response.status = 'Error';
                        response.message = 'El parámetro Coordinador del Asunto es obligatorio, pero no tiene valor o es nulo';
                        response.StatusCode = res.StatusCode = 404;
                    }else if(listBody.Ejecutivo == null || listBody.Ejecutivo == ''){
                        response.status = 'Error';
                        response.message = 'El parámetro Ejecutivo del Asunto es obligatorio, pero no tiene valor o es nulo';
                        response.StatusCode = res.StatusCode = 404;
                    }else if(listBody.EstatusAsunto == null || listBody.EstatusAsunto == ''){
                        response.status = 'Error';
                        response.message = 'El parámetro Estatus del Asunto es obligatorio, pero no tiene valor o es nulo';
                        response.StatusCode = res.StatusCode = 404;
                    }else if(listBody.FechaAsunto == null ){// comparar fecha valida
                        response.status = 'Error';
                        response.message = 'El parámetro Fecha del Asunto es obligatorio, pero no tiene valor o es nulo';
                        response.StatusCode = res.StatusCode = 404;
                    }else if(listBody.IdAsunto == null || listBody.IdAsunto == ''){
                        response.status = 'Error';
                        response.message = 'El parámetro Id del Asunto es obligatorio, pero no tiene valor o es nulo';
                        response.StatusCode = res.StatusCode = 404;
                    }else if(listBody.IdPrincipalEjecutivo == null || listBody.IdPrincipalEjecutivo == ''){
                        response.status = 'Error';
                        response.message = 'El parámetro Id Principal Ejecutivo del Asunto es obligatorio, pero no tiene valor o es nulo';
                        response.StatusCode = res.StatusCode = 404;
                    }else if(listBody.IdPrincipalActor == null || listBody.IdPrincipalActor == ''){
                        response.status = 'Error';
                        response.message = 'El parámetro Id Principal Actorto del Asunto es obligatorio, pero no tiene valor o es nulo';
                        response.StatusCode = res.StatusCode = 404;
                    }else if(listBody.IdPrincipalCoordinador == null || listBody.IdPrincipalCoordinador == ''){
                        response.status = 'Error';
                        response.message = 'El parámetro Id Principal Coordinador del Asunto es obligatorio, pero no tiene valor o es nulo';
                        response.StatusCode = res.StatusCode = 404;
                    }else if(listBody.IdPrincipalDemandado == null || listBody.IdPrincipalDemandado == ''){
                        response.status = 'Error';
                        response.message = 'El parámetro Id Principal Demandado del Asunto es obligatorio, pero no tiene valor o es nulo';
                        response.StatusCode = res.StatusCode = 404;
                    }else if(listBody.IdPrincipaSocio == null || listBody.IdPrincipaSocio == ''){
                        response.status = 'Error';
                        response.message = 'El parámetro Id Principa Socio del Asunto es obligatorio, pero no tiene valor o es nulo';
                        response.StatusCode = res.StatusCode = 404;
                    }else if(listBody.IdPrincipaTerceroPerjudicado == null || listBody.IdPrincipaTerceroPerjudicado == ''){
                        response.status = 'Error';
                        response.message = 'El parámetro Id Principa Tercero Perjudicado del Asunto es obligatorio, pero no tiene valor o es nulo';
                        response.StatusCode = res.StatusCode = 404;
                    }else if(listBody.IdPrincipalCliente == null || listBody.IdPrincipalCliente == ''){
                        response.status = 'Error';
                        response.message = 'El parámetro Id Principal Cliente del Asunto es obligatorio, pero no tiene valor o es nulo';
                        response.StatusCode = res.StatusCode = 404;
                    }else if(listBody.IdPrincipalCorresonsal == null || listBody.IdPrincipalCorresonsal == ''){
                        response.status = 'Error';
                        response.message = 'El parámetro Id Principal Corresonsal del Asunto es obligatorio, pero no tiene valor o es nulo';
                        response.StatusCode = res.StatusCode = 404;
                    }else if(listBody.IdPrincipalFacturar_a == null || listBody.IdPrincipalFacturar_a == ''){
                        response.status = 'Error';
                        response.message = 'El parámetro Id Principal Facturar a del Asunto es obligatorio, pero no tiene valor o es nulo';
                        response.StatusCode = res.StatusCode = 404;
                    }else if(listBody.IdPrincipalTitular == null || listBody.IdPrincipalTitular == ''){
                        response.status = 'Error';
                        response.message = 'El parámetro Id Principal Titular del Asunto es obligatorio, pero no tiene valor o es nulo';
                        response.StatusCode = res.StatusCode = 404;
                    }else if(listBody.NombreAsunto == null || listBody.NombreAsunto == ''){
                        response.status = 'Error';
                        response.message = 'El parámetro Nombre del Asunto es obligatorio, pero no tiene valor o es nulo';
                        response.StatusCode = res.StatusCode = 404;
                    }else if(listBody.IdPincipalTerceroInteresado == null || listBody.IdPincipalTerceroInteresado == ''){
                        response.status = 'Error';
                        response.message = 'El parámetro Id Pincipal Tercero Interesado del Asunto es obligatorio, pero no tiene valor o es nulo';
                        response.StatusCode = res.StatusCode = 404;
                    }else{
                        listAsunto.add(asunto);                            
                        if(listAsunto.size() > 0){
                            insert listAsunto;
                            response.StatusCode = res.StatusCode = 200;
                            response.status = 'Success';
                            response.AsuntoID = listAsunto[0].Id;
                            response.message = 'El Asunto con el Id '+ listAsunto[0].Id +' se creo exitosamente';
                            System.debug('Asunto creado ||' + listAsunto);
                        } 
                    }
                }
            }else{
                response.status = 'Warning';
                response.message = 'El Asunto que desea crear ya existe en Salesforce';
                response.StatusCode = res.StatusCode = 201;
                response.AsuntoID = idAsunto;
                response.asunto = result;
                System.debug('Asunto existente ||' + aux_claveArea);
            }

        }catch(Exception e){
           	System.debug('Error en  ||' + e);
            response.StatusCode = res.StatusCode = 500;
            response.status = 'Error';
            response.message = 'Error al crear el Asunto en : '+ e.getMessage() + 'En la linea :' + e.getLineNumber() + ' error ' + e.getTypeName() ;
        }
        return response;
    }
    
    public class WrapperAsuntos{
        
        public String ClaveArea; 
        public String ClaveAsunto;
        public String Contacto;   
        public String Coordinador;
        public String Ejecutivo;
        public String EstatusAsunto;
        public Date FechaAsunto;
        public String IdAsunto;
        public String IdKWD1;
        public String IdKWD2;
        public String IdLegacyActor;
        public String IdLegacyCliente;
        public String IdLegacyCoordinador;
        public String IdLegacyCorresponsal;
        public String IdLegacyDemandado;
        public String IdLeagacyEjecutivo;
        public String IdLegacyFacturar_a;
        public String IdLegacySocio;
        public String IdLegacyTerceroPerjudiado;
        public String IdLegacyTitular;
        public String IdLegacyTerceroInteresado;
        public String IdPrincipalEjecutivo;
        public String IdPrincipalActor;
        public String IdPrincipalCoordinador;
        public String IdPrincipalDemandado;
        public String IdPrincipaSocio;
        public String IdPrincipaTerceroPerjudicado;
        public String IdPrincipalCliente;
        public String IdPrincipalCorresonsal;
        public String IdPrincipalFacturar_a;
        public String IdPrincipalTitular;
        public String IdPincipalTerceroInteresado;
        public String NombreAsunto;
        
    }
    global class ResponseWrapper{
        public List<Asunto__c> asunto {get; set;}
        public String Status;
        public String Message;
        public Integer StatusCode;
        public String AsuntoID;
        public ResponseWrapper(){}

    }
}