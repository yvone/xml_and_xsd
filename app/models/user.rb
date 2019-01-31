class User < ApplicationRecord

	# validate :validate_for_xml

	def build_xml(person:)
		# return unless self.valid?
		fecha_expedicion = Time.zone.now.to_date

		xml = Nokogiri::XML::Builder.new(:encoding => 'UTF-8'){ |xml|

			xml.FichaDatos(version: '1.0') {

				xml.Titulo(
					fechaExpedicion: fecha_expedicion,
					creadoPor: person
				)

				xml.Persona(
					nombre: self.name,
					apellidos: self.surname
				)

				xml.Contacto(
					correoElectronico: self.email,
					curp: self.curp
				)

			}

		}.doc

		xslt = Nokogiri::XSLT( Rails.root.join('lib', 'ficha', 'ficha_datos.xslt').read )
		cadena_original = xslt.transform(xml).content.to_s
		Rails.logger.debug("> cadena_original: #{cadena_original}")
		# firmar la cadena original: certificado.sign64(cadena_original))

		xsd = Nokogiri::XML::Schema( Rails.root.join('lib', 'ficha', 'fd.xsd').read )
		errors = xsd.validate(xml).map{ |error| error.message }
		return errors if errors.any?

		xml

	rescue StandardError => e
		backtrace = e.backtrace.join("\n")
		Rails.logger.error("#{e.message.to_s}\n\n#{backtrace}")
		
		return ['No se pudo crear la ficha']
	end

	private

		def validate_for_xml
			errors.add(:base, :curp) unless self.curp&.length == 18
			errors.add(:base, :email) unless self.email.present?
			errors.add(:base, :name) unless self.name.present?
		end
end
